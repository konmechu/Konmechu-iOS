//
//  CustomSegmentedControl.swift
//  konmechu
//
//  Created by 정재연 on 6/26/24.
//

import UIKit

class CustomSegmentedControl: UISegmentedControl {

    private var indicatorView: UIView?

        override init(items: [Any]?) {
            super.init(items: items)
            setupSegmentedControl()
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setupSegmentedControl()
        }

        private func setupSegmentedControl() {
            removeDivider()
            setText()
            setupIndicatorView()
            layoutIfNeeded()
            updateIndicatorForSelectedIndex(animated: false)
        }

        private func removeDivider() {
            self.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        }

        public func setText() {
            let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                  NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .semibold)]
            self.setTitleTextAttributes(textAttributes, for: .normal)
        }

        private func setupIndicatorView() {
            indicatorView = UIView()
            indicatorView?.backgroundColor = UIColor.white.withAlphaComponent(0.3)
            indicatorView?.layer.cornerRadius = 17
            indicatorView?.layer.masksToBounds = true
            indicatorView?.translatesAutoresizingMaskIntoConstraints = false
            addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        }

        @objc private func segmentChanged() {
            updateIndicatorForSelectedIndex(animated: true)
        }

        private func updateIndicatorForSelectedIndex(animated: Bool) {
            guard let indicatorView = indicatorView else { return }

            // Remove existing indicator view
            indicatorView.removeFromSuperview()

            // Find the selected segment's view
            let selectedIndex = self.selectedSegmentIndex
            let selectedSubview = subviews[selectedIndex]

            selectedSubview.addSubview(indicatorView)

            // Set up constraints for the indicator view
            NSLayoutConstraint.deactivate(indicatorView.constraints)
            NSLayoutConstraint.activate([
                indicatorView.centerXAnchor.constraint(equalTo: selectedSubview.centerXAnchor),
                indicatorView.centerYAnchor.constraint(equalTo: selectedSubview.centerYAnchor),
                indicatorView.widthAnchor.constraint(equalToConstant: 55),
                indicatorView.heightAnchor.constraint(equalToConstant: 34)
            ])

            if animated {
                UIView.animate(withDuration: 0.3) {
                    self.layoutIfNeeded()
                }
            } else {
                self.layoutIfNeeded()
            }
        }
}
