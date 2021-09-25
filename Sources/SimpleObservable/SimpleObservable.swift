import Foundation
import UIKit

// MARK: - Observable

public final class Observable<T> {
    public var value: T {
        didSet {
            executeOnMainThread {
                self.listener?(self.value)
            }
        }
    }

    private var listener: ((T) -> Void)?

    public init(_ value: T) {
        self.value = value
    }

    public func bind(_ closure: @escaping (T) -> Void) {
        executeOnMainThread {
            closure(self.value)
        }
        assert(listener == nil, "Binding already used")
        listener = closure
    }

    public func bind<Object: AnyObject>(to object: Object, keyPath: ReferenceWritableKeyPath<Object, T>) {
        assert(listener == nil, "Binding already used")
        listener = { value in
            object[keyPath: keyPath] = value
        }
        executeOnMainThread {
            object[keyPath: keyPath] = self.value
        }
    }
}

// MARK: - Publisher

public final class Publisher<T> {
    public func publish(_ value: T) {
        executeOnMainThread {
            self.listener?(value)
        }
    }

    private var listener: ((T) -> Void)?

    public func bind(_ closure: @escaping (T) -> Void) {
        assert(listener == nil, "Binding already used")
        listener = closure
    }
}

extension Publisher where T == Void {
    public func publish() {
        publish(())
    }
}

// MARK: - ObservableButton

public class ObservableButton: UIButton {
    public final class ButtonObservable {
        let tap = Publisher<()>()
    }

    public let observable = ButtonObservable()

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        addTarget(self, action: #selector(taped), for: .touchUpInside)
    }

    @objc final private func taped() {
        observable.tap.publish()
    }
}

func executeOnMainThread(closure: @escaping () -> Void) {
    if Thread.isMainThread {
        closure()
    } else {
        DispatchQueue.main.async {
            closure()
        }
    }
}
