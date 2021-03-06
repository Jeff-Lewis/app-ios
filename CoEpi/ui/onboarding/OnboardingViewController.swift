import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var monitorLabel: UILabel!
    @IBOutlet weak var alertsLabel: UILabel!
    @IBOutlet weak var tagLineLabel: UILabel!
    
    @IBOutlet weak var getStartedButton: OnboardingButton!
    @IBOutlet weak var privacyButton: UIButton!
    
    private let viewModel: OnboardingViewModel

    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: Self.self), bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradient()
        setupButtons()
        setupLabels()
    }
    
    func setupGradient() {
        guard let view = view as? GradientView else { return }
        view.startColor = Theme.color.coepiBlue
        view.endColor = Theme.color.coepiAqua
        view.endLocation = 0.4
    }
    
    func setupButtons() {
        privacyButton.setAttributedTitle(privacyButtonTitle, for: .normal)
        getStartedButton.setAttributedTitle(getStartedButtonTitle, for: .normal)
    }
    
    func setupLabels() {
        
        let pointSize: CGFloat = 14
        let color = UIColor.darkText
        
        trackLabel.attributedText = OnboardingStrings.track.markupAttributed(pointSize: pointSize, color: color)
        monitorLabel.attributedText = OnboardingStrings.monitor.markupAttributed(pointSize: pointSize, color: color)
        alertsLabel.attributedText = OnboardingStrings.alerts.markupAttributed(pointSize: pointSize, color: color)
        
        tagLineLabel.text = OnboardingStrings.collaborate
        
    }
    
    @IBAction func onCloseClick(_ sender: UIButton) {
        viewModel.onCloseClick()
    }
    
}

private extension OnboardingViewController {
    
    var privacyButtonTitle: NSAttributedString {
        
        let attrs: FontAttributes = [
            .foregroundColor: Theme.color.coepiUnderlineButton,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        return NSAttributedString(string: OnboardingStrings.howYourDataIsUsed,
                                  attributes: attrs)
        
    }
    
    var getStartedButtonTitle: NSAttributedString {
        
        let attrs: FontAttributes = [
            .foregroundColor: UIColor.white,
            .kern: 5
        ]
        
        return NSAttributedString(string: OnboardingStrings.getStarted.uppercased(),
                                  attributes: attrs)
        
    }
    
}
