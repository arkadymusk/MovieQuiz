import UIKit

final class MovieQuizViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet weak var noButtonClickedOutlet: UIButton!
    @IBOutlet weak var yesButtonClickedOutlet: UIButton!
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questions = QuizQuestionMock.questions
    
    // MARK: - Lyfecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        show(quiz: convert(model: questions[0]))
    }
    
    //MARK: - Actions
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = true
        
        yesButtonClickedOutlet.isEnabled = false
        noButtonClickedOutlet.isEnabled = false
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.yesButtonClickedOutlet.isEnabled = true
            self.noButtonClickedOutlet.isEnabled = true
        }
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = false
        
        yesButtonClickedOutlet.isEnabled = false
        noButtonClickedOutlet.isEnabled = false
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
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
        
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 8 // толщина рамки
        let color = isCorrect ? UIColor.ypGreen : UIColor.ypRed
        imageView.layer.borderColor = color.cgColor
        imageView.layer.cornerRadius = 20 // радиус скругления углов рамки
        
        // запускаем задачу через 1 секунду c помощью диспетчера задач
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // код, который мы хотим вызвать через 1 секунду
            self.showNextQuestionOrResults()
        }
    }
    
    //MARK: - Private Helpers
    
    private func show(quiz result: QuizResults) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            // заново показываем первый вопрос
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    private func convert(model: QuizQuestion) -> QuizStep {
        let questionStep = QuizStep(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)"
        )
        return questionStep
    }
    
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            // идем в состояние "результат квиза"
            let title = "Этот раунд окончен!"
            let text = "Ваш результат: \(correctAnswers)/10"
            let buttonText = "Сыграть еще раз"
            let viewModel = QuizResults(title: title, text: text, buttonText: buttonText)
            imageView.layer.borderColor = UIColor.clear.cgColor
            show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            // идем в состояние "вопрос показан"
            imageView.layer.borderColor = UIColor.clear.cgColor
            show(quiz: convert(model: questions[currentQuestionIndex]))
        }
    }
}







/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
*/
