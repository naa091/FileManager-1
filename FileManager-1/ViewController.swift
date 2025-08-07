import UIKit

final class ViewController: UIViewController {

    private var fileNames: [String] = []

    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Documents"

        setupTableView()
        setupNavBar()
        NotificationCenter.default.addObserver(self, selector: #selector(loadFiles), name: .sortOrderChanged, object: nil)
        
        loadFiles()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DocumentCell.self, forCellReuseIdentifier: "DocumentCell")
    }

    private func setupNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Добавить фотографию",
            style: .plain,
            target: self,
            action: #selector(addPhotoTapped)
        )
    }

    @objc private func addPhotoTapped() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }

    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    private func deleteFile(named fileName: String) {
        let url = getDocumentsDirectory().appendingPathComponent(fileName)
        try? FileManager.default.removeItem(at: url)
        loadFiles()
    }
    
    @objc private func loadFiles() {
        let documentsURL = getDocumentsDirectory()
        if let contents = try? FileManager.default.contentsOfDirectory(atPath: documentsURL.path) {
            let isAscending = UserDefaults.standard.bool(forKey: "sort_ascending")
            fileNames = isAscending ? contents.sorted() : contents.sorted().reversed()
        }
        tableView.reloadData()
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fileNames.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath) as! DocumentCell
        let fileName = fileNames[indexPath.row]
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
        cell.configure(with: fileURL)
        return cell
    }

    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            let fileToDelete = fileNames[indexPath.row]
            deleteFile(named: fileToDelete)
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        picker.dismiss(animated: true)

        guard let image = info[.originalImage] as? UIImage else { return }
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }

        let fileName = "photo_\(UUID().uuidString).jpg"
        let url = getDocumentsDirectory().appendingPathComponent(fileName)

        do {
            try data.write(to: url)
            loadFiles()
        } catch {
            print("Error saving file:", error)
        }
    }
}



