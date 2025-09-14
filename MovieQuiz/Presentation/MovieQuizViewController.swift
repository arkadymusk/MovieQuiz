import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    // MARK: - Properties
    
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var noButtonClickedOutlet: UIButton!
    @IBOutlet private weak var yesButtonClickedOutlet: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var QuestionTitleLabel: UILabel!
    private var correctAnswers = 0
    
    private var currentQuestionIndex = 0
    private let questionsAmount = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var statisticService: StatisticServiceProtocol?
    private var alertPresenter: AlertPresenterProtocol?
    
    // MARK: - Lyfecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statisticService = StatisticService()
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        alertPresenter = AlertPresenter(delegate: self)
        
        setQuizUIHidden(true)
        
        showLoadingIndicator()
        questionFactory?.loadData()
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        setQuizUIHidden(false)
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    //MARK: - Actions
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else { return }
        
        yesButtonClickedOutlet.isEnabled = false
        noButtonClickedOutlet.isEnabled = false
        
        showAnswerResult(isCorrect: currentQuestion.correctAnswer)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.yesButtonClickedOutlet.isEnabled = true
            self.noButtonClickedOutlet.isEnabled = true
        }
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else { return }
        
        yesButtonClickedOutlet.isEnabled = false
        noButtonClickedOutlet.isEnabled = false
        
        showAnswerResult(isCorrect: !currentQuestion.correctAnswer)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.yesButtonClickedOutlet.isEnabled = true
            self.noButtonClickedOutlet.isEnabled = true
        }
    }
    
    //MARK: - Setup Methods
    
    private func show(quiz step: QuizStep) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        let color = isCorrect ? UIColor.ypGreen : UIColor.ypRed
        imageView.layer.borderColor = color.cgColor
        imageView.layer.cornerRadius = 20
        
        // запускаем задачу через 1 секунду c помощью диспетчера задач
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            // код, который мы хотим вызвать через 1 секунду
            self.showNextQuestionOrResults()
        }
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            self.showLoadingIndicator()
            self.questionFactory?.loadData()
        }
        alertPresenter?.show(model: model)
    }
    
    //MARK: - Private Helpers
    
    private func convert(model: QuizQuestion) -> QuizStep {
        let questionStep = QuizStep(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
        return questionStep
    }
    
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            // идем в состояние "результат квиза"
            
            statisticService?.store(correct: correctAnswers, total: questionsAmount)
            
            let title = "Этот раунд окончен!"
            let text = """
                Ваш результат: \(correctAnswers)/10 \n
                Количество сыгранных квизов: \(statisticService?.gamesCount ?? 0) \n
                Рекорд: \(statisticService?.bestGame.correct ?? 0)/\(statisticService?.bestGame.total ?? 0) (\(statisticService?.bestGame.date.dateTimeString ?? "")) \n
                Средняя точность: \(String(format: "%.2f", statisticService?.totalAccuracy ?? 0.0))%
            """
            let buttonText = "Сыграть еще раз"
            
            let alertModel = AlertModel(
                title: title,
                message: text,
                buttonText: buttonText
            ) { [weak self] in
                guard let self = self else { return }
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                self.questionFactory?.reset()
                self.questionFactory?.requestNextQuestion()
            }

            alertPresenter?.show(model: alertModel)
            imageView.layer.borderColor = UIColor.clear.cgColor

        } else {
            currentQuestionIndex += 1
            // идем в состояние "вопрос показан"
            imageView.layer.borderColor = UIColor.clear.cgColor
            self.questionFactory?.requestNextQuestion()
        }
    }
    
    private func setQuizUIHidden(_ hidden: Bool) {
        imageView.isHidden = hidden
        textLabel.isHidden = hidden
        counterLabel.isHidden = hidden
        yesButtonClickedOutlet.isHidden = hidden
        noButtonClickedOutlet.isHidden = hidden
        QuestionTitleLabel.isHidden = hidden
    }
}

// MARK: - AlertPresenterDelegate

extension MovieQuizViewController: AlertPresenterDelegate {
    func presentAlert(_ alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
}

