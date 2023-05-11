//
//  FetchingViewController.swift
//  RxSwiftTutorial
//
//  Created by NhanHoo23 on 11/05/2023.
//

import MTSDK
import RxSwift
import RxCocoa

//MARK: Init and Variables
class FetchingViewController: UIViewController {

    //Variables
    private let tableView = UITableView()
    
    private let urlMusic = "https://rss.applemarketingtools.com/api/v2/us/music/most-played/50/songs.json"
    private let musicFileURL = cachedFileURL("musics.json")
    private var musics = BehaviorRelay<[Music]>(value: [])
    private let disposeBag = DisposeBag()
}

//MARK: Lifecycle
extension FetchingViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        subcription()
        setupView()
        readData()
        loadAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

}

//MARK: SetupView
extension FetchingViewController {
    private func setupView() {
        view.backgroundColor = .systemBackground
        
        title = "Fetching Data"
        
        tableView >>> view >>> {
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            $0.dataSource = self
            $0.delegate = self
            $0.registerReusedCell(FetchingTableViewCell.self)
            $0.backgroundColor = .clear
            $0.separatorStyle = .none
        }

    }
}

//MARK:  Functions
extension FetchingViewController {
    private func subcription() {
        musics.asObservable()
            .subscribe(onNext: { _ in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
            .disposed(by: disposeBag)
    }
    
    static func cachedFileURL(_ fileName: String) -> URL {
        return FileManager.default
            .urls(for: .cachesDirectory, in: .allDomainsMask) //truy cập vào danh sách của thư mục cache
            .first!
            .appendingPathComponent(fileName)
    }
    
    private func loadAPI() {
        //create obserbable
        let response = Observable<String>.of(urlMusic)
            .map { urlString -> URL in //B1: biến đổi urlString -> URL
                return URL(string: urlString)!
            }
            .map { url -> URLRequest in //B2: biến đổi url -> URLRequest
                return URLRequest(url: url)
            }
            .flatMap { request -> Observable<(response: HTTPURLResponse, data: Data)> in //B3: nhận response
                return URLSession.shared.rx.response(request: request) //share.rx của RxCocoa sẽ gọi toán tử response với tham số request
            }
            .share(replay: 1) //Khi subcribe nhiều lần thì mọi bước trên sẽ chạy lại từ đầu và lưu vào bộ nhớ đệm, để tránh tốn tài nguyên thì toán tử share sẽ giữ lại phần tử cuổi cùng. Các subcriber khác sẽ lấy được dữ liệu ngay lập tức mà không cần chạy lại các bước trên
        
        //parse data
        response
            .filter { response, _ -> Bool in
                return 200..<300 ~= response.statusCode
                // trong HTTP các status code đại diện cho kết quả yêu cầu nếu nằm trong khoảng 200 -> 299 thì success
                // toán tử ~= là kiểm tra xem responese.statusCode có nằm trong khoảng kia hay ko
                // ví dụ a ~= b là xem b có nằm trong khoảng a ko
            }
            .map { _, data -> [Music] in
                let decoder = JSONDecoder()
                let result = try? decoder.decode(FeedResult.self, from: data)

                return result?.feed.results ?? []
            }
            .filter { object in
                return !object.isEmpty
            }
            .subscribe (onNext: { musics in
                printDebug("musics count: \(musics.count)")
                self.progressMusics(newMusics: musics)
            })
            .disposed(by: disposeBag)
    }
    
    private func progressMusics(newMusics: [Music]) {
        self.musics.accept(newMusics)
        
        let encoder = JSONEncoder() //chuyển data sang json
        if let musicsData = try? encoder.encode(newMusics) {
            try? musicsData.write(to: musicFileURL, options: .atomic) //lưu data xuống bộ nhớ đệm
        }
    }
    
    private func readData() { //đọc data từ bộ nhớ đềm lên trước khi load API tránh việc màn hình trống trơn khi chưa có dữ liệu
        let decoder = JSONDecoder()
        if let musicsData = try? Data(contentsOf: musicFileURL), let preMusics = try? decoder.decode([Music].self, from: musicsData) {
            self.musics.accept(preMusics)
        }
    }
    
}



//MARK: Delegate
extension FetchingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musics.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusable(cellClass: FetchingTableViewCell.self, indexPath: indexPath)
        cell.configsCell()
        cell.textLabel?.text = musics.value[indexPath.row].name
        cell.textLabel?.textColor = .label
        cell.selectionStyle = .none
        
        return cell
    }
}
