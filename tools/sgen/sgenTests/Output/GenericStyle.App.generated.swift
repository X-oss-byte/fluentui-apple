///// Autogenerated file
//
//// swiftlint:disable all
//import UIKit
//
//import Stardust
//
//public class Application {
//	@objc dynamic public class func preferredContentSizeCategory() -> UIContentSizeCategory {
//		return .large
//	}
//}
//
//fileprivate var __ApperanceProxyHandle: UInt8 = 0
//fileprivate var __ThemeAwareHandle: UInt8 = 0
//fileprivate var __ObservingDidChangeThemeHandle: UInt8 = 0
//
//protocol AppStylesheetManagerTheming {
//	static func currentTheme() -> App.GenericStyle
//	func themeInit()
//}
//
//extension AppStylesheetManagerTheming {
//	static func currentTheme() -> App.GenericStyle {
//		return App.GenericStyle.shared()
//	}
//	func themeInit() {
//		
//	}
//}
//
//public class AppStylesheetManager: AppStylesheetManagerTheming {
//	@objc dynamic public class func stylesheet(_ stylesheet: App.GenericStyle) -> App.GenericStyle {
//		return currentTheme()
//	}
//
//	public static let `default` = AppStylesheetManager()
//	public static var S: App.GenericStyle {
//		return currentTheme()
//	}
//
//}
//
//public extension S {
//
//}
//public enum App {
//
///// Entry point for the app stylesheet
//public class GenericStyle: NSObject {
//
//	public class func shared() -> GenericStyle {
//		 struct __ { static let _sharedInstance = GenericStyle() }
//		return __._sharedInstance
//	}
//	//MARK: - ExtendedEmptyListView
//	public var _ExtendedEmptyListView: ExtendedEmptyListViewAppearanceProxy?
//	open func ExtendedEmptyListViewStyle() -> ExtendedEmptyListViewAppearanceProxy {
//		if let override = _ExtendedEmptyListView { return override }
//			return ExtendedEmptyListViewAppearanceProxy(proxy: { return Stardust.GenericStyle.shared() })
//		}
//	public var ExtendedEmptyListView: ExtendedEmptyListViewAppearanceProxy {
//		get { return self.ExtendedEmptyListViewStyle() }
//		set { _ExtendedEmptyListView = newValue }
//	}
//	open class ExtendedEmptyListViewAppearanceProxy: Stardust.GenericStyle.EmptyListViewAppearanceProxy {
//
//		//MARK: - GenericStyleExtendedEmptyListViewcolor
//		override open func colorStyle() -> Stardust.GenericStyle.EmptyListViewAppearanceProxy.colorAppearanceProxy {
//			if let override = _color { return override }
//				return GenericStyleExtendedEmptyListViewcolorAppearanceProxy(proxy: { return Stardust.GenericStyle.shared() })
//			}
//		open class GenericStyleExtendedEmptyListViewcolorAppearanceProxy: Stardust.GenericStyle.EmptyListViewAppearanceProxy.colorAppearanceProxy {
//
//			//MARK: normal 
//			override open func normalProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> UIColor {
//				if let override = _normal { return override }
//					return UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
//				}
//		}
//
//	}
//	//MARK: - ExtendedTheme
//	public var _ExtendedTheme: ExtendedThemeAppearanceProxy?
//	open func ExtendedThemeStyle() -> ExtendedThemeAppearanceProxy {
//		if let override = _ExtendedTheme { return override }
//			return ExtendedThemeAppearanceProxy(proxy: { return GenericStyle.shared() })
//		}
//	public var ExtendedTheme: ExtendedThemeAppearanceProxy {
//		get { return self.ExtendedThemeStyle() }
//		set { _ExtendedTheme = newValue }
//	}
//	open class ExtendedThemeAppearanceProxy {
//		public let mainProxy: () -> GenericStyle
//		public init(proxy: @escaping () -> GenericStyle) {
//			self.mainProxy = proxy
//		}
//
//		//MARK: generic 
//		public var _generic: Int?
//		open func genericProperty(_ traitCollection: UITraitCollection? = UIScreen.main.traitCollection) -> Int {
//			if let override = _generic { return override }
//			return Int(1)
//			}
//		public var generic: Int {
//			get { return self.genericProperty() }
//			set { _generic = newValue }
//		}
//	}
//
//}
//}