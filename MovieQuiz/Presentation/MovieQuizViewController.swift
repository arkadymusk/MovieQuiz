import UIKit


final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
>>>>>>> 272b339 (sprint 5 is over)
    
    // MARK: - Properties
    
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet weak var noButtonClickedOutlet: UIButton!
    @IBOutlet weak var yesButtonClickedOutlet: UIButton!
    

    private var correctAnswers = 0
    
    private var currentQuestionIndex = 0
    private let questionsAmount = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    
    private var alertPresenter: AlertPresenterProtocol?
>>>>>>> 272b339 (sprint 5 is over)
    
    // MARK: - Lyfecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
=======
        
        questionFactory = QuestionFactory(delegate: self)
        alertPresenter = AlertPresenter(delegate: self)
        
        questionFactory?.requestNextQuestion()
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
>>>>>>> 272b339 (sprint 5 is over)
    }
    
    //MARK: - Actions
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else { return }
>>>>>>> 272b339 (sprint 5 is over)
        let givenAnswer = true
        
        yesButtonClickedOutlet.isEnabled = false
        noButtonClickedOutlet.isEnabled = false
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
>>>>>>> 272b339 (sprint 5 is over)
            self.yesButtonClickedOutlet.isEnabled = true
            self.noButtonClickedOutlet.isEnabled = true
        }
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else { return }
>>>>>>> 272b339 (sprint 5 is over)
        let givenAnswer = false
        
        yesButtonClickedOutlet.isEnabled = false
        noButtonClickedOutlet.isEnabled = false
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
>>>>>>> 272b339 (sprint 5 is over)
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
>>>>>>> 272b339 (sprint 5 is over)
            // код, который мы хотим вызвать через 1 секунду
            self.showNextQuestionOrResults()
        }
    }
    
    //MARK: - Private Helpers
    
>>>>>>> 272b339 (sprint 5 is over)
    
    
    private func convert(model: QuizQuestion) -> QuizStep {
        let questionStep = QuizStep(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
>>>>>>> 272b339 (sprint 5 is over)
        )
        return questionStep
    }
    
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
>>>>>>> 272b339 (sprint 5 is over)
            // идем в состояние "результат квиза"
            let title = "Этот раунд окончен!"
            let text = "Ваш результат: \(correctAnswers)/10"
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

>>>>>>> 272b339 (sprint 5 is over)
        } else {
            currentQuestionIndex += 1
            // идем в состояние "вопрос показан"
            imageView.layer.borderColor = UIColor.clear.cgColor
            self.questionFactory?.requestNextQuestion()
        }
    }
}

// MARK: - AlertPresenterDelegate

extension MovieQuizViewController: AlertPresenterDelegate {
    func presentAlert(_ alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
}


>>>>>>> 272b339 (sprint 5 is over)
