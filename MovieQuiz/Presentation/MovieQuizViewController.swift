import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    
    // MARK: - Properties
    
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var noButtonClickedOutlet: UIButton!
    @IBOutlet weak var yesButtonClickedOutlet: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var QuestionTitleLabel: UILabel!
    private var presenter: MovieQuizPresenter!
    
    // MARK: - Lyfecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.hidesWhenStopped = true
        presenter = MovieQuizPresenter(viewController: self)

        
        setQuizUIHidden(true)
        
        showLoadingIndicator()
    }
    
    //MARK: - Actions
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        presenter.noButtonClicked()
    }
    
    
    //MARK: - Setup Methods
    
    func setButtonsEnabled(_ isEnabled: Bool) {
        yesButtonClickedOutlet.isEnabled = isEnabled
        noButtonClickedOutlet.isEnabled = isEnabled
    }
    
    func show(quiz step: QuizStep) {
        setQuizUIHidden(false)
        hideLoadingIndicator()
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.cornerRadius = 20
    }
    
    func clearImageBorder() {
        imageView.layer.borderColor = UIColor.clear.cgColor
    }
    
    func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }
    
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            
            self.presenter.restartGame()
            
            self.showLoadingIndicator()
            self.presenter.reloadData()
        }
        presenter.alertPresenter?.show(model: model)
    }
    
//MARK: - Private Helpers
    
    
    
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

