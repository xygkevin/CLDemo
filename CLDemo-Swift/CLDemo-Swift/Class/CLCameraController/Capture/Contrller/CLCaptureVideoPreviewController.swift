//
//  CLCaptureVideoPreviewController.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2024/2/26.
//

import AVFoundation
import UIKit

// MARK: - JmoVxia---CLCaptureVideoPreviewControllerDelegate

protocol CLCaptureVideoPreviewControllerDelegate: AnyObject {
    func previewViewController(_ controller: CLCaptureVideoPreviewController, didClickDoneButtonWithVideoUrl: URL)
}

// MARK: - JmoVxia---类-属性

class CLCaptureVideoPreviewController: UIViewController {
    init(url: URL) {
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playback)
        try? session.setActive(true)
        self.url = url
        player = AVPlayer(playerItem: AVPlayerItem(asset: .init(url: url)))
        playerLayer = AVPlayerLayer(player: player)
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }

    private lazy var mainStackView: UIStackView = {
        let view = UIStackView()
        view.isUserInteractionEnabled = true
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        view.insetsLayoutMarginsFromSafeArea = false
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = .zero
        view.spacing = 0
        return view
    }()

    private lazy var toolBar: CLCameraPreviewToolBar = {
        let view = CLCameraPreviewToolBar()
        view.setContentCompressionResistancePriority(.required, for: .vertical)
        view.delegate = self
        return view
    }()

    private lazy var previewStackView: UIStackView = {
        let view = UIStackView()
        view.isUserInteractionEnabled = false
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        view.insetsLayoutMarginsFromSafeArea = false
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = .zero
        view.spacing = 0
        return view
    }()

    private lazy var previewView: UIView = {
        let view = UIView()
        return view
    }()

    private var url: URL

    private var player: AVPlayer

    private var playerLayer: AVPlayerLayer

    weak var delegate: CLCaptureVideoPreviewControllerDelegate?
}

// MARK: - JmoVxia---生命周期

extension CLCaptureVideoPreviewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        makeConstraints()
        configData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

// MARK: - JmoVxia---布局

private extension CLCaptureVideoPreviewController {
    func setupUI() {
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(previewStackView)
        mainStackView.addArrangedSubview(toolBar)
        previewStackView.addArrangedSubview(previewView)
        previewView.layer.addSublayer(playerLayer)
    }

    func makeConstraints() {
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - JmoVxia---数据

private extension CLCaptureVideoPreviewController {
    func configData() {
        view.setNeedsDisplay()
        view.layoutIfNeeded()
        NotificationCenter.default.addObserver(self, selector: #selector(playToEndTime), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        playerLayer.videoGravity = .resizeAspect
        playerLayer.frame = previewView.bounds
        player.play()
    }
}

// MARK: - JmoVxia---override

extension CLCaptureVideoPreviewController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .portrait
    }

    override var prefersStatusBarHidden: Bool {
        true
    }
}

// MARK: - JmoVxia---objc

@objc private extension CLCaptureVideoPreviewController {
    func playToEndTime() {
        player.seek(to: .zero)
        player.play()
    }
}

// MARK: - JmoVxia---私有方法

private extension CLCaptureVideoPreviewController {}

// MARK: - JmoVxia---公共方法

extension CLCaptureVideoPreviewController {}

// MARK: - JmoVxia---CLCapturePreviewToolBarDelegate

extension CLCaptureVideoPreviewController: CLCameraPreviewToolBarDelegate {
    func toolBarDidClickCancelButton(_ toolBar: CLCameraPreviewToolBar) {
        dismiss(animated: false, completion: nil)
    }

    func toolBarDidClickDoneButton(_ toolBar: CLCameraPreviewToolBar) {
        delegate?.previewViewController(self, didClickDoneButtonWithVideoUrl: url)
    }
}
