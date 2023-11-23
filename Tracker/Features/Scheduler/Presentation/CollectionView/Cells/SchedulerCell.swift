import UIKit

class SchedulerCell: SettingsMenuCell {
    static let Identifier = "SchedulerCell"
    
    var day: WeekDays?
    
    var isActive = false
    
    private var delegate: SchedulerCellsDelegate?
    
    private let switcher = UISwitch()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDelegate(_ delegate: SchedulerCellsDelegate) {
        self.delegate = delegate
    }
    
    func initCell(_ type: SettingsMenuCellType) {
        label.text = day?.description()
        super.setupCell(type)
        configureSwither()
    }
    
    private func configureSwither() {
        contentView.addSubView(
            switcher,
            trailing: AnchorOf(contentView.trailingAnchor, -24),
            centerY: AnchorOf(contentView.centerYAnchor)
        )
        
        switcher.onTintColor = .ypBlue
        switcher.setOn(isActive, animated: false)
        switcher.addTarget(self, action: #selector(onSwitcherClick), for: .allEvents)
    }
    
    @objc
    private func onSwitcherClick() {
        guard let day else { return }
        if switcher.isOn { delegate?.setSelectedDay(day) }
        if !switcher.isOn { delegate?.removeUnselectedDay(day) }
    }
}
