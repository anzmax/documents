import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate {
    
    var images: [URL] = []
    var imagePicker = UIImagePickerController()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
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
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: documentURL, includingPropertiesForKeys: nil)
            images = contents.filter { $0.pathExtension.lowercased() == "jpg" || $0.pathExtension.lowercased() == "jpeg" }
            tableView.reloadData()
        } catch {
            print("Error loading images: \(error)")
        }
    }
    
    func deleteItem(at index: Int) {
        let imageUrl = images[index]
        do {
            try FileManager.default.removeItem(at: imageUrl)
            images.remove(at: index)
            tableView.reloadData()
        } catch {
            print("Error deleting image: \(error)")
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteItem(at: indexPath.row)
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = images[indexPath.row].lastPathComponent
        return cell
    }
}

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
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
        picker.dismiss(animated: true)
    }
}
