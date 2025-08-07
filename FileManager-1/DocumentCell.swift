import UIKit

final class DocumentCell: UITableViewCell {

    private let docImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.backgroundColor = .secondarySystemBackground
        return iv
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(docImageView)
        docImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            docImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            docImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            docImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            docImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            docImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with fileURL: URL) {
        if let image = UIImage(contentsOfFile: fileURL.path) {
            docImageView.image = image
        } else {
            docImageView.image = nil
        }
    }
}


