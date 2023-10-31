import UIKit

class CustomCell: UITableViewCell {
    
    static let id = "CustomCell"
    
    let previewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(previewImageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            previewImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            previewImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            previewImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            previewImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            previewImageView.heightAnchor.constraint(equalToConstant: 180)
        ])
    }
}
