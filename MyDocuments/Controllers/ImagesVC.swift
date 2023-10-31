import UIKit

class ImagesVC: UIViewController, UINavigationControllerDelegate {

    var images: [URL] = []
    var imagePicker = UIImagePickerController()
    let imageService = ImageService.shared

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.id)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        loadImagesFromDocumentDirectory()
    }

    private func setupViews() {
        view.backgroundColor = .systemGray6
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add photo", style: .plain, target: self, action: #selector(addPhoto))
        view.addSubview(tableView)
        imagePicker.delegate = self
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    @objc func addPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true)
        }
    }

    func loadImagesFromDocumentDirectory() {
        images = imageService.loadImagesFromDocumentDirectory()
        tableView.reloadData()
    }

    func deleteItem(at index: Int) {
        let imageUrl = images[index]
        imageService.deleteImage(at: imageUrl)
        images.remove(at: index)
        tableView.reloadData()
    }
}

extension ImagesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteItem(at: indexPath.row)
        }
    }
}

extension ImagesVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.id, for: indexPath) as! CustomCell
        let imageURL = images[indexPath.row]
        if let image = UIImage(contentsOfFile: imageURL.path) {
            cell.previewImageView.image = image
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = ImageDetailVC()

        let imageURL = images[indexPath.row]
        if let image = UIImage(contentsOfFile: imageURL.path) {
            detailVC.image = image
        }
        navigationController?.pushViewController(detailVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ImagesVC: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            saveImage(image)
        }
        picker.dismiss(animated: true)
    }
    
    func saveImage(_ image: UIImage) {
        if let data = image.jpegData(compressionQuality: 1.0), let imageURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(UUID().uuidString + ".jpg") {
            do {
                try data.write(to: imageURL)
                images.append(imageURL)
                tableView.reloadData()
            } catch {
                print("Error saving image: \(error)")
            }
        }
    }
}
