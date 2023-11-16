import UIKit

class SettingsMenuCell: UICollectionViewCell {
    
    let contextView = UIView()
    
    let label = UILabel()
    
    let subLabel = UILabel()
    
    var subLabelIndent: CGFloat = 0
    
    let separator = UIView()
    
    var onCellClick = [() -> Void]()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        
        contentView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(onContentViewClick))
        )
        
        contextView.layer.cornerRadius = 16
        contextView.backgroundColor = .ypLightGray.withAlphaComponent(0.4)
        
        label.font = Font.ypRegular17
        label.textColor = .ypBlack
        
        subLabel.font = Font.ypRegular17
        subLabel.textColor = .ypGray
        
        separator.backgroundColor = .ypGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        removeLabelsFromContextView()
        contextView.removeFromSuperview()
        label.removeFromSuperview()
        subLabel.removeFromSuperview()
        separator.removeFromSuperview()
    }
    
    func setupCell(_ type: SettingsMenuCellType) {
        switch type {
        case .first:
            setupFirstItem()
        case .regular:
            setupRegularItem()
        case .last:
            setupLastItem()
        case .single:
            setupSingleItem()
        }
    }
    
    func updateLabels() {
        removeLabelsFromContextView()
        setLabelOnContexView()
    }
    
    func addActionOnCellClick(_ action: @escaping () -> Void) {
        onCellClick.append(action)
    }
    
    private func setupSingleItem() {
        setContexOnSuperView()
        setLabelOnContexView()
    }
    
    private func setupFirstItem() {
        setContexOnSuperView(correctionBottom: contextView.layer.cornerRadius)
        setLabelOnContexView()
    }
    
    private func setupRegularItem() {
        let correction = contextView.layer.cornerRadius
        setContexOnSuperView(correctionTop: -correction, correctionBottom: correction)
        setSeparatorOnContextView()
        setLabelOnContexView()
    }
    
    private func setupLastItem() {
        setContexOnSuperView(correctionTop: -contextView.layer.cornerRadius)
        setSeparatorOnContextView()
        setLabelOnContexView()
    }
    
    private func setLabelOnContexView() {
        if let text = subLabel.text {
            if text.isEmpty { setSingleLabelOnContextView() }
            if !text.isEmpty { setBothLabelsOnContextView() }
        } else {
            setSingleLabelOnContextView()
        }
    }
    
    private func setContexOnSuperView(correctionTop: CGFloat = 0, correctionBottom: CGFloat = 0) {
        contentView.addSubView(
            contextView,
            top: AnchorOf(contentView.topAnchor, correctionTop),
            bottom: AnchorOf(contentView.bottomAnchor, correctionBottom),
            leading: AnchorOf(contentView.leadingAnchor),
            trailing: AnchorOf(contentView.trailingAnchor)
        )
    }
    
    private func setSeparatorOnContextView() {
        contentView.addSubView(
            separator, heigth: 1,
            top: AnchorOf(contentView.topAnchor),
            leading: AnchorOf(contentView.leadingAnchor, 16),
            trailing: AnchorOf(contentView.trailingAnchor, -16)
        )
    }
        
    private func setSingleLabelOnContextView() {
        contextView.addSubView(
            label,
            leading: AnchorOf(contentView.leadingAnchor, 16),
            centerY: AnchorOf(contentView.centerYAnchor)
        )
    }
    
    private func setBothLabelsOnContextView() {
        let separateLabelsView = UIView()
        
        contextView.addSubView(
            separateLabelsView, heigth: subLabelIndent,
            centerY: AnchorOf(contentView.centerYAnchor)
        )
        
        contextView.addSubView(
            label,
            bottom: AnchorOf(separateLabelsView.topAnchor),
            leading: AnchorOf(contentView.leadingAnchor, 16)
        )
        
        contextView.addSubView(
            subLabel,
            top: AnchorOf(separateLabelsView.bottomAnchor),
            leading: AnchorOf(label.leadingAnchor)
        )
    }
    
    private func removeLabelsFromContextView() {
        label.removeFromSuperview()
        subLabel.removeFromSuperview()
    }
    
    @objc
    private func onContentViewClick() {
        if onCellClick.isEmpty { return }
        for action in onCellClick {
            action()
        }
    }
}
