# Simple observable

Very simple `Observable` and `Publisher` implementation for iOS apps. 

Useful if you want to use a bit of simple reactive programming but do not want to add the full `RxSwift` or use `Combine`.

## Observable

Create an `Observable` instance providing a default value.

```swift
let isLoading = Observable<Bool>(false)
```

you can assign and read the value of this observable using the `value` property, for example when using it in a view model

```swift
isLoading.value = true
```

You can bind to the value changes using the `bind` function, for example in a view controller

```swift
viewModel.isLoading.bind { [weak self] isLoading in
    self?.loadingView.isHidden = !isLoading
}
```

You can also use a version of `bind` that accepts a keypath

```swift
viewModel.isLoading.bind(to: userDetailsView, keyPath: \.isHidden)
```

## Publisher

`Publisher` is an observable without an initial value. An `Observable` is used for storing state, a `Publisher` is used for events.

After you create a `Publisher` instance

```swift
let onError = Publisher<Error>()
```

you can publish new values to this publisher with the `publish` method, for example when using it in a view model

```swift
onError.publish(ApiError.InvalidCredentials)
```

You can bind to the value changes using the `bind` function, for example in a view controller

```swift
viewModel.onError.bind { [weak self] error in
    self?.showAlert(error)
}
```

### ObservableButton

`ObservableButton` can be created in code or used from a storyboard. You can use the `ObservableButton`  to easily subscribe to the tap event

```swift
loginButton.observable.tap.bind { [weak self] in
    self?.login()
}
```

### Good to know

You can bind to an observable or an publisher just once. This is not a technical limitation but a design decision.

Boith observable and publisher always call the `bind` method on the main thread so no need to worry about binding changes to UI elements.
