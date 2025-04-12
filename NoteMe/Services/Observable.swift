import Foundation

final class Observable<T> {
    var value: T {
        didSet {
            observer?(value)
        }
    }

    private var observer: ((T) -> Void)?

    init(_ value: T) {
        self.value = value
    }

    func bind(_ listener: @escaping (T) -> Void) {
        self.observer = listener
        listener(value)
    }
}
