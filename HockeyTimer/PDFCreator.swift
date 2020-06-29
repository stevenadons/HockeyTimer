//
//  PDFCreator.swift
//  HockeyTimer
//
//  Created by Steven Adons on 29/06/2020.
//  Copyright © 2020 StevenAdons. All rights reserved.
//

import UIKit
import PDFKit


class PDFCreator: NSObject {
    
    
    // MARK: - Properties
    
    private var game: HockeyGame!
    
    private let horizontalInset: CGFloat = 20
    private let verticalInset: CGFloat = 32
    private let stripeLength: CGFloat = 32
    private let stripeInset: CGFloat = 6
    
    private let fontForTimeIndicator: UIFont = UIFont.systemFont(ofSize: 16, weight: .regular)
    private let fontForMinuteIndicator: UIFont = UIFont.systemFont(ofSize: 18, weight: .regular)
    private let fontForPlayerIndicator: UIFont = UIFont.systemFont(ofSize: 16, weight: .semibold)
    private let fontForScoreIndicator: UIFont = UIFont.systemFont(ofSize: 24, weight: .heavy)

    private var timeFormatter: DateFormatter {
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        return timeFormatter
    }
    
    
    // MARK: - Init
    
    init(game: HockeyGame) {
        
        self.game = game
    }
    
    
    // MARK: - Public Methods
    
    func createReport() -> Data {
        
        let pdfMetaData = [kCGPDFContextCreator: "HockeyUpp App", kCGPDFContextAuthor: "HockeyUpp User", kCGPDFContextTitle: "Game Summary"]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pageWidth = 5.8 * 72.0 // A5: 5.8 inch - PDF has 72.0 px per inch
        let pageHeight = 16.6 * 72.0 // A5: 8.3 inch - PDF has 72.0 px per inch
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        let data = renderer.pdfData { (context) in
            context.beginPage()
            let scoresBottom = addScores(pageRect)
            let homeAndAwayBottom = addHomeAndAway(pageRect)
            let startTimeBottom = addStartTime(context: context.cgContext, pageRect: pageRect, top: scoresBottom)
            let eventsBottom = addEvents(context: context.cgContext, pageRect: pageRect, top: startTimeBottom)
        }
        return data
    }
    
    
    // MARK: - Private Methods
    
    private func addScores(_ pageRect: CGRect) -> CGFloat {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 64, weight: .bold), NSAttributedString.Key.paragraphStyle: paragraphStyle]
        
        let attributedHomeScore = NSAttributedString(string: String(game.homeScore), attributes: attributes)
        let contentWidth = (pageRect.width - horizontalInset * 2.0)
        let scoreWidth = contentWidth * 0.2
        let homeScoreRect = CGRect(x: horizontalInset, y: verticalInset, width: scoreWidth, height: attributedHomeScore.size().height)
        attributedHomeScore.draw(in: homeScoreRect)
        
        let attributedAwayScore = NSAttributedString(string: String(game.awayScore), attributes: attributes)
        let awayScoreRect = CGRect(x: pageRect.width - horizontalInset - scoreWidth, y: verticalInset, width: scoreWidth, height: attributedAwayScore.size().height)
        attributedAwayScore.draw(in: awayScoreRect)
        
        return homeScoreRect.origin.y + homeScoreRect.size.height
    }
    
    private func addHomeAndAway(_ pageRect: CGRect) -> CGFloat {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .semibold), NSAttributedString.Key.paragraphStyle: paragraphStyle]
        
        let attributedHome = NSAttributedString(string: "Home", attributes: attributes)
        let contentWidth = (pageRect.width - horizontalInset * 2.0)
        let textWidth = contentWidth * 0.2
        let homeRect = CGRect(x: horizontalInset + contentWidth * (0.2 + 0.05), y: verticalInset, width: textWidth, height: attributedHome.size().height)
        attributedHome.draw(in: homeRect)
        
        let attributedAway = NSAttributedString(string: "Away", attributes: attributes)
        let awayRect = CGRect(x: pageRect.width / 2.0 + contentWidth * 0.05, y: verticalInset, width: textWidth, height: attributedAway.size().height)
        attributedAway.draw(in: awayRect)
        
        return homeRect.origin.y + homeRect.size.height
    }
    
    private func addStartTime(context: CGContext, pageRect: CGRect, top: CGFloat) -> CGFloat {
        
        guard let startTime = game.startTime else {
            return top
        }
        
        let vertPadding: CGFloat = 6
        
        let y = addStripeStart(context: context, pageRect: pageRect, top: top)
        let newY = addStripeEnd(context: context, pageRect: pageRect, top: y)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes = [NSAttributedString.Key.font: fontForTimeIndicator, NSAttributedString.Key.paragraphStyle: paragraphStyle]
        
        let timeString = timeFormatter.string(from: startTime)
        let fullString = "Game Started at " + timeString
        let attributedString = NSAttributedString(string: fullString, attributes: attributes)
        let contentWidth = (pageRect.width - horizontalInset * 2.0)
        let rect = CGRect(x: horizontalInset, y: newY + vertPadding, width: contentWidth, height: attributedString.size().height)
        attributedString.draw(in: rect)
        
        let newestY = addStripeStart(context: context, pageRect: pageRect, top: rect.origin.y + rect.size.height + vertPadding)
        
        return newestY
    }
    
    
    private func addEvents(context: CGContext, pageRect: CGRect, top: CGFloat) -> CGFloat {
        
        let filteredEvents = game.events.filter {
            return $0.inMinute != nil
        }
        let sortedEvents = filteredEvents.sorted { $0.inMinute! < $1.inMinute! }
        var topOfEvent: CGFloat = top
        var newTopOfEvent: CGFloat = topOfEvent
        for event in sortedEvents {
            switch event.type {
            case .penaltyCard(_, _, _, _):
                newTopOfEvent = addPenaltyCard(event, context: context, pageRect: pageRect, top: topOfEvent)
            case .goal(_, _, _, _):
                newTopOfEvent = addGoal(event, context: context, pageRect: pageRect, top: topOfEvent)
            default:
                print("Trying to handle wrong event")
            }
            topOfEvent = newTopOfEvent
        }
        return newTopOfEvent
    }
    
    private func addPenaltyCard(_ event: GameEvent, context: CGContext, pageRect: CGRect, top: CGFloat) -> CGFloat {
        
        guard case let .penaltyCard(cardType, inMinute, player, team) = event.type else { return top }
        
        let vertPadding: CGFloat = 6
        
        // Stripe
        let y = addStripeEnd(context: context, pageRect: pageRect, top: top)
        
        // Minute
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes = [NSAttributedString.Key.font: fontForMinuteIndicator, NSAttributedString.Key.paragraphStyle: paragraphStyle]
        
        let string = String(inMinute) + "'"
        let attributedString = NSAttributedString(string: string, attributes: attributes)
        let width = pageRect.width * 0.1
        let rect = CGRect(x: (pageRect.width - width) / 2.0, y: y + vertPadding, width: width, height: attributedString.size().height)
        attributedString.draw(in: rect)
        
        // Player
        var playerAttributedString = NSAttributedString()
        var playerRect = CGRect.zero
        let playerAttributes = [NSAttributedString.Key.font: fontForPlayerIndicator, NSAttributedString.Key.paragraphStyle: paragraphStyle]
        
        if let player = player, let team = team {
            let playerString = (player == LS_STAFF || player == LS_CAPTAIN) ? player : "Player " + player
            playerAttributedString = NSAttributedString(string: playerString, attributes: playerAttributes)
            let playerWidth = pageRect.width * 0.25
            let playerInset = ((pageRect.width - width) / 2.0 - playerWidth) / 2.0
            if team == .Home {
                playerRect = CGRect(x: playerInset, y: y + vertPadding, width: playerWidth, height: playerAttributedString.size().height)
            } else {
                playerRect = CGRect(x: (pageRect.width - width) / 2.0 + width + playerInset, y: y + vertPadding, width: playerWidth, height: playerAttributedString.size().height)
            }
            playerAttributedString.draw(in: playerRect)
        }
        
        // Stripe
        let newY = addStripeStart(context: context, pageRect: pageRect, top: rect.origin.y + rect.size.height + vertPadding)
        
        return newY
    }
    
    private func addGoal(_ event: GameEvent, context: CGContext, pageRect: CGRect, top: CGFloat) -> CGFloat {
        
        guard case let .goal(team, homeScore, awayScore, inMinute) = event.type else { return top }

        let vertPadding: CGFloat = 6
        
        // Stripe
        let y = addStripeEnd(context: context, pageRect: pageRect, top: top)
        
        // Goal
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let scoreAttributes = [NSAttributedString.Key.font: fontForScoreIndicator, NSAttributedString.Key.paragraphStyle: paragraphStyle]
        let scoreString = String(homeScore) + " - " + String(awayScore)
        let attributedScoreString = NSAttributedString(string: scoreString, attributes: scoreAttributes)
        let scoreWidth = pageRect.width * 0.4
        let scoreRect = CGRect(x: (pageRect.width - scoreWidth) / 2.0, y: y + vertPadding, width: scoreWidth, height: attributedScoreString.size().height)
        attributedScoreString.draw(in: scoreRect)
        
        // Minute
        let attributes = [NSAttributedString.Key.font: fontForMinuteIndicator, NSAttributedString.Key.paragraphStyle: paragraphStyle]
        let string = String(inMinute) + "'"
        let attributedString = NSAttributedString(string: string, attributes: attributes)
        let width = pageRect.width * 0.1
        let rect = CGRect(x: (pageRect.width - width) / 2.0, y: scoreRect.origin.y + scoreRect.size.height, width: width, height: attributedString.size().height)
        attributedString.draw(in: rect)
        
        // Stripe
        let newY = addStripeStart(context: context, pageRect: pageRect, top: rect.origin.y + rect.size.height + vertPadding)
        
        return newY
    }
    
    private func addStripe(context: CGContext, pageRect: CGRect, top: CGFloat, topInset: CGFloat, length: CGFloat, bottomInset: CGFloat) -> CGFloat {
           
           context.saveGState()
           context.setLineWidth(1.0)
           context.setStrokeColor(UIColor.secondaryLabel.cgColor)
           
           let startPoint = CGPoint(x: pageRect.width / 2.0, y: top + topInset)
           context.move(to: startPoint)
           context.addLine(to: CGPoint(x: startPoint.x, y: startPoint.y + length))
           context.strokePath()
           context.restoreGState()
           
           return top + topInset + length + bottomInset
       }
    
    private func addStripeStart(context: CGContext, pageRect: CGRect, top: CGFloat) -> CGFloat {
        
        return addStripe(context: context, pageRect: pageRect, top: top, topInset: stripeInset, length: stripeLength / 2.0, bottomInset: 0)
    }
    
    private func addStripeEnd(context: CGContext, pageRect: CGRect, top: CGFloat) -> CGFloat {
        
        return addStripe(context: context, pageRect: pageRect, top: top, topInset: 0, length: stripeLength / 2.0, bottomInset: stripeInset)
    }
    
    

}
