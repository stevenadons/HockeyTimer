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
    
    private let horizontalInset: CGFloat = 16
    private let verticalInset: CGFloat = 32
    private let penaltyCardsOverviewTopInset: CGFloat = 12
    private let stripeLength: CGFloat = 36
    private let stripeInset: CGFloat = 6
    private let startTimeVertPadding: CGFloat = 44
    private let startTimeDistanceToStripe: CGFloat = 6
    private let penaltyCardVertPadding: CGFloat = 6
    private let penaltyCardDrawingPaddingFromMinute: CGFloat = 4
    private let goalToMinutePadding: CGFloat = 8
    private let roundedRectVertInset: CGFloat = 4
    private let roundedRectHorInset: CGFloat = 16
    private let footerLineInset: CGFloat = 18
    private let footerLineWidth: CGFloat = 1
    private let footerPadding: CGFloat = 4
    
    private let fontForScores: UIFont = UIFont.systemFont(ofSize: 44, weight: .heavy)
    private let fontForNumberOfCards: UIFont = UIFont.systemFont(ofSize: 16, weight: .semibold)
    private let fontForTimeIndicator: UIFont = UIFont.systemFont(ofSize: 16, weight: .regular)
    private let fontForMinuteIndicator: UIFont = UIFont.systemFont(ofSize: 18, weight: .regular)
    private let fontForPlayerIndicator: UIFont = UIFont.systemFont(ofSize: 16, weight: .semibold)
    private let fontForScoreIndicator: UIFont = UIFont.systemFont(ofSize: 22, weight: .bold)
    private let fontForFooter: UIFont = UIFont.systemFont(ofSize: 14, weight: .light)
    
    private var userInterfaceStyle: UIUserInterfaceStyle = .light

    private var timeFormatter: DateFormatter {
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        return timeFormatter
    }
    private var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter
    }
    private var drawingHeightForScoreLabel: CGFloat {
        let attributes = [NSAttributedString.Key.font: fontForScores]
        let attributedScore = NSAttributedString(string: "1", attributes: attributes)
        return attributedScore.size().height
    }
    
    
    // MARK: - Init
    
    init(game: HockeyGame) {
        
        self.game = game
    }
    
    
    // MARK: - Public Methods
    
    func createReport(_ userInterFaceStyle: UIUserInterfaceStyle) -> Data {
        
        self.userInterfaceStyle = userInterFaceStyle
        
        let pdfMetaData = [kCGPDFContextCreator: "HockeyUpp App", kCGPDFContextAuthor: "HockeyUpp User", kCGPDFContextTitle: "Game Report"]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pageWidth: CGFloat = 5.8 * 72.0 // A5: 5.8 inch - PDF has 72.0 px per inch
        let pageHeight = calculateHeight() // 16.6 * 72.0 // 16.6 * 72.0 // A5: 8.3 inch - PDF has 72.0 px per inch
        let pageRect = CGRect(x: 0.0, y: 0.0, width: pageWidth, height: pageHeight)
        
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        let data = renderer.pdfData { (context) in
            context.beginPage()
            addBackground(context.cgContext, pageRect: pageRect)
            let scoresBottom = addScores(pageRect)
            let homeAndAwayBottom = addHomeAndAway(pageRect)
            guard game.startTime != nil else {
                addMessageGameReady(context: context.cgContext, pageRect: pageRect, top: scoresBottom)
                let footerHeight: CGFloat = footerLineWidth + footerPadding + drawingHeightForFont(fontForFooter) + penaltyCardVertPadding
                let _ = addFooter(context: context.cgContext, pageRect: pageRect, top: pageHeight - footerHeight)
                return
            }
            let _ = addPenaltyCardsOverview(context: context.cgContext, pageRect: pageRect, top: homeAndAwayBottom)
            let startTimeBottom = addStartTime(context: context.cgContext, pageRect: pageRect, top: scoresBottom)
            let eventsBottom = addEvents(context: context.cgContext, pageRect: pageRect, top: startTimeBottom)
            let _ = addEndTime(context: context.cgContext, pageRect: pageRect, top: eventsBottom)
            let footerHeight: CGFloat = footerLineWidth + footerPadding + drawingHeightForFont(fontForFooter) + penaltyCardVertPadding
            let _ = addFooter(context: context.cgContext, pageRect: pageRect, top: pageHeight - footerHeight)
        }
        return data
    }
    
    
    // MARK: - Private Methods
    
    private func drawingHeightForFont(_ font: UIFont) -> CGFloat {
        
        let attributes = [NSAttributedString.Key.font: font]
        let attributedScore = NSAttributedString(string: "1", attributes: attributes)
        return attributedScore.size().height
    }
    
    private func calculateHeight() -> CGFloat {
        
        let scoresHeight: CGFloat = verticalInset + drawingHeightForFont(fontForScores)
        let halfStripeHeight: CGFloat = stripeInset + stripeLength / 2.0
        let startTimeHeight: CGFloat = startTimeVertPadding + drawingHeightForFont(fontForTimeIndicator) + startTimeDistanceToStripe + halfStripeHeight
        let penaltyCardHeight: CGFloat = penaltyCardVertPadding + halfStripeHeight + drawingHeightForFont(fontForMinuteIndicator) + halfStripeHeight + penaltyCardVertPadding
        let goalHeight: CGFloat = penaltyCardHeight + goalToMinutePadding + drawingHeightForFont(fontForScoreIndicator)
        let endTimeHeight: CGFloat = halfStripeHeight + startTimeVertPadding + drawingHeightForFont(fontForTimeIndicator) + penaltyCardVertPadding
        let footerHeight: CGFloat = footerLineWidth + footerPadding + drawingHeightForFont(fontForFooter) + penaltyCardVertPadding
        
        var resultHeight: CGFloat = 0.0
        resultHeight += scoresHeight
        resultHeight += startTimeHeight
        if game.startTime != nil {
            resultHeight += penaltyCardHeight * CGFloat(game.penaltyCards.count)
            resultHeight += goalHeight * CGFloat(game.goals.count)
            resultHeight += endTimeHeight
        }
        resultHeight += startTimeVertPadding / 2.0
        resultHeight += footerHeight
        return resultHeight
    }
    
    private func addBackground(_ context: CGContext, pageRect: CGRect) {
        
        context.saveGState()
        context.setFillColor(UIColor.systemBackground.cgColor)
        context.addRect(pageRect)
        context.drawPath(using: .fillStroke)
        context.restoreGState()
    }
    
    private func addScores(_ pageRect: CGRect) -> CGFloat {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes = [NSAttributedString.Key.font: fontForScores, NSAttributedString.Key.paragraphStyle: paragraphStyle, NSAttributedString.Key.foregroundColor: UIColor.label]
        
        let attributedHomeScore = NSAttributedString(string: String(game.homeScore), attributes: attributes)
        let contentWidth = (pageRect.width - horizontalInset * 2.0)
        let scoreWidth = contentWidth * 0.195
        let homeScoreRect = CGRect(x: horizontalInset, y: verticalInset, width: scoreWidth, height: attributedHomeScore.size().height)
        attributedHomeScore.draw(in: homeScoreRect)
        
        let attributedAwayScore = NSAttributedString(string: String(game.awayScore), attributes: attributes)
        let awayScoreRect = CGRect(x: pageRect.width - horizontalInset - scoreWidth, y: verticalInset, width: scoreWidth, height: attributedAwayScore.size().height)
        attributedAwayScore.draw(in: awayScoreRect)
        
        return homeScoreRect.origin.y + homeScoreRect.size.height
    }
    
    private func addHomeAndAway(_ pageRect: CGRect) -> CGFloat {
        
        let homeParagraphStyle = NSMutableParagraphStyle()
        homeParagraphStyle.alignment = .right
        let homeAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .semibold), NSAttributedString.Key.paragraphStyle: homeParagraphStyle, NSAttributedString.Key.foregroundColor: UIColor.label]
        
        let attributedHome = NSAttributedString(string: LS_HOME_TEAM, attributes: homeAttributes)
        let contentWidth = (pageRect.width - horizontalInset * 2.0)
        let textWidth = contentWidth * 0.2
        let homeRect = CGRect(x: pageRect.width / 2.0 - textWidth - contentWidth * 0.035, y: verticalInset, width: textWidth, height: attributedHome.size().height)
        attributedHome.draw(in: homeRect)
        
        let awayParagraphStyle = NSMutableParagraphStyle()
        awayParagraphStyle.alignment = .left
        let awayAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .semibold), NSAttributedString.Key.paragraphStyle: awayParagraphStyle, NSAttributedString.Key.foregroundColor: UIColor.label]
        
        let attributedAway = NSAttributedString(string: LS_AWAY_TEAM, attributes: awayAttributes)
        let awayRect = CGRect(x: pageRect.width / 2.0 + contentWidth * 0.035, y: verticalInset, width: textWidth, height: attributedAway.size().height)
        attributedAway.draw(in: awayRect)
        
        return homeRect.origin.y + homeRect.size.height
    }
    
    private func addMessageGameReady(context: CGContext, pageRect: CGRect, top: CGFloat) {
        
        guard game.startTime == nil else { return  }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes = [NSAttributedString.Key.font: fontForTimeIndicator, NSAttributedString.Key.paragraphStyle: paragraphStyle, NSAttributedString.Key.foregroundColor: UIColor.label]
        
        let fullString = LS_GAME_READY_TO_START
        let attributedString = NSAttributedString(string: fullString, attributes: attributes)
        let contentWidth = (pageRect.width - horizontalInset * 2.0)
        let rect = CGRect(x: horizontalInset, y: top + startTimeVertPadding, width: contentWidth, height: attributedString.size().height)
        attributedString.draw(in: rect)
    }
    
    private func addPenaltyCardsOverview(context: CGContext, pageRect: CGRect, top: CGFloat) {
        
        let y = top + penaltyCardsOverviewTopInset
        let contentWidth = (pageRect.width - horizontalInset * 2.0)
        let digitWidth = contentWidth * 0.04
        
        let redHomeX = pageRect.width / 2 - contentWidth * 0.015 - digitWidth
        let yellowHomeX = addThumbnailPenaltyCard(context: context, pageRect: pageRect, team: .Home, type: .red, x: redHomeX, y: y)
        let greenHomeX = addThumbnailPenaltyCard(context: context, pageRect: pageRect, team: .Home, type: .yellow, x: yellowHomeX, y: y)
        let _ = addThumbnailPenaltyCard(context: context, pageRect: pageRect, team: .Home, type: .green, x: greenHomeX, y: y)
        
        let greenAwayX = pageRect.width / 2 + contentWidth * 0.015 + digitWidth
        let yellowAwayX = addThumbnailPenaltyCard(context: context, pageRect: pageRect, team: .Away, type: .green, x: greenAwayX, y: y)
        let redAwayX = addThumbnailPenaltyCard(context: context, pageRect: pageRect, team: .Away, type: .yellow, x: yellowAwayX, y: y)
        let _ = addThumbnailPenaltyCard(context: context, pageRect: pageRect, team: .Away, type: .red, x: redAwayX, y: y)
    }
    
    private func addThumbnailPenaltyCard(context: CGContext, pageRect: CGRect, team: Team, type: CardType, x: CGFloat, y: CGFloat) -> CGFloat {
        
        // Find Cards
        let validPenaltyCards = game.penaltyCards.filter { $0.team != nil }
        guard !validPenaltyCards.isEmpty else { return x }
        let teamPenaltyCards = validPenaltyCards.filter { $0.team == team }
        guard !teamPenaltyCards.isEmpty else { return x }
        let cardsOfType = teamPenaltyCards.filter { $0.type == type }
        guard !cardsOfType.isEmpty else { return x }
        
        // Drawing Helpers
        let ribbonRatio: CGFloat = 0.275
        let contentWidth = (pageRect.width - horizontalInset * 2.0)
        let digitWidth = contentWidth * 0.04
        let digitContainer = CGSize(width: digitWidth, height: digitWidth * 1.5)

        // Draw Number
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes = [NSAttributedString.Key.font: fontForNumberOfCards, NSAttributedString.Key.foregroundColor: UIColor.label, NSAttributedString.Key.paragraphStyle: paragraphStyle]
        let attributedNumberCards = NSAttributedString(string: String(cardsOfType.count), attributes: attributes)
        let numberRect = CGRect(x: x, y: y, width: digitWidth, height: digitWidth * 1.5)
        attributedNumberCards.draw(in: numberRect)
        
        // Draw Card
        let card = Card(type: type)
        let graphicsSide = (type == .green) ? digitContainer.height * 0.6 : digitContainer.height * 0.45
        let graphicsSize = CGSize(width: graphicsSide, height: graphicsSide)
        let path = card.pathInSize(graphicsSize)
        
        var cardYOffset = digitContainer.height * ribbonRatio * 0.8
        if type == .green {
            cardYOffset -= digitContainer.height * 0.05
        }
        let cardXOffset = (digitContainer.height - graphicsSide) / 2
        let translateWithinContainer = CGAffineTransform(translationX: cardXOffset, y: cardYOffset)
        path.apply(translateWithinContainer)
        
        let translateFromCornerToRightPlace = CGAffineTransform(translationX: x - digitWidth, y: y)
        path.apply(translateFromCornerToRightPlace)
        
        context.saveGState()
        context.setLineWidth(1.0)
        context.setStrokeColor(UIColor.clear.cgColor)
        context.setFillColor(card.color().cgColor)
        
        context.addPath(path.cgPath)
        context.drawPath(using: .fillStroke)
        context.restoreGState()
        
        // Return new X
        if team == .Home {
            return x - digitWidth * 2.0 - contentWidth * 0.0125
        } else {
            return x + digitWidth * 2.0 + contentWidth * 0.0125
        }
    }
    
    private func addStartTime(context: CGContext, pageRect: CGRect, top: CGFloat) -> CGFloat {
        
        guard let startTime = game.startTime else {
            return top
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes = [NSAttributedString.Key.font: fontForTimeIndicator, NSAttributedString.Key.paragraphStyle: paragraphStyle, NSAttributedString.Key.foregroundColor: UIColor.label]
        
        let timeString = timeFormatter.string(from: startTime)
        let fullString = LS_GAME_STARTED_AT + timeString
        let attributedString = NSAttributedString(string: fullString, attributes: attributes)
        let contentWidth = (pageRect.width - horizontalInset * 2.0)
        let rect = CGRect(x: horizontalInset, y: top + startTimeVertPadding, width: contentWidth, height: attributedString.size().height)
        attributedString.draw(in: rect)
        
        let newestY = addStripeStart(context: context, pageRect: pageRect, top: rect.origin.y + rect.size.height + startTimeDistanceToStripe)
        
        return newestY
    }
    
    private func addEndTime(context: CGContext, pageRect: CGRect, top: CGFloat) -> CGFloat {
        
        // Stripe
        let y = addStripeEnd(context: context, pageRect: pageRect, top: top)
        
        // Time String
        let string = (game.endTime != nil) ? LS_GAME_ENDED_AT + timeFormatter.string(from: game.endTime!) : LS_GAME_IS_RUNNING
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes = [NSAttributedString.Key.font: fontForTimeIndicator, NSAttributedString.Key.paragraphStyle: paragraphStyle, NSAttributedString.Key.foregroundColor: UIColor.label]
        
        let attributedString = NSAttributedString(string: string, attributes: attributes)
        let contentWidth = (pageRect.width - horizontalInset * 2.0)
        let rect = CGRect(x: horizontalInset, y: y + penaltyCardVertPadding, width: contentWidth, height: attributedString.size().height)
        attributedString.draw(in: rect)
        
        return rect.origin.y + rect.size.height + penaltyCardVertPadding
    }
    
    private func addEvents(context: CGContext, pageRect: CGRect, top: CGFloat) -> CGFloat {
        
        var events: [Event] = []
        events.append(contentsOf: game.goals)
        events.append(contentsOf: game.penaltyCards)
        let sortedEvents = events.sorted { $0.time < $1.time }
        
        var topOfEvent: CGFloat = top
        var newTopOfEvent: CGFloat = top
        var homeScore: Int = 0
        var awayScore: Int = 0
        
        for event in sortedEvents {
            
            if let penaltyCard = event as? PenaltyCard {
                newTopOfEvent = addPenaltyCard(penaltyCard, context: context, pageRect: pageRect, top: topOfEvent)
            } else if let goal = event as? Goal {
                switch goal.team {
                case .Home:
                    homeScore += 1
                case .Away:
                    awayScore += 1
                }
                newTopOfEvent = addGoal(goal, homeScore: homeScore, awayScore: awayScore, context: context, pageRect: pageRect, top: topOfEvent)
            }
            topOfEvent = newTopOfEvent
        }
        return newTopOfEvent
    }
    
    private func addPenaltyCard(_ penaltyCard: PenaltyCard, context: CGContext, pageRect: CGRect, top: CGFloat) -> CGFloat {
        
        // Stripe
        let y = addStripeEnd(context: context, pageRect: pageRect, top: top)
        
        // Minute
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes = [NSAttributedString.Key.font: fontForMinuteIndicator, NSAttributedString.Key.paragraphStyle: paragraphStyle, NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel]
        
        let string = String(penaltyCard.inMinute) + "'"
        let attributedString = NSAttributedString(string: string, attributes: attributes)
        let width = pageRect.width * 0.1
        let rect = CGRect(x: (pageRect.width - width) / 2.0, y: y + penaltyCardVertPadding, width: width, height: attributedString.size().height)
        attributedString.draw(in: rect)
        
        // Player
        if let player = penaltyCard.player, let team = penaltyCard.team {
            
            // Penalty Card
            let container = CGSize(width: attributedString.size().height * 2.5, height: attributedString.size().height * 2.5)
            let card = Card(type: penaltyCard.type)
            let ribbonRatio: CGFloat = 0.275
            let ratio: CGFloat = penaltyCard.type == .green ? 0.6 : 0.45
            let graphicsSide = container.height * ratio
            let graphicsSize = CGSize(width: graphicsSide, height: graphicsSide)
            let path = card.pathInSize(graphicsSize)
            
            var cardYOffset = container.height * ribbonRatio * 0.8
            if card.type == .green {
                cardYOffset -= container.height * 0.05
            }
            let cardXOffset = (container.height - graphicsSide) / 2
            let translateWithinContainer = CGAffineTransform(translationX: cardXOffset, y: cardYOffset)
            path.apply(translateWithinContainer)
            if team == .Home {
                let translateX: CGFloat = rect.origin.x - penaltyCardDrawingPaddingFromMinute - container.width
                let translateY: CGFloat = rect.origin.y - (container.height - rect.size.height) / 2.0
                let translateFromCornerToRightPlace = CGAffineTransform(translationX: translateX, y: translateY)
                path.apply(translateFromCornerToRightPlace)
            } else {
                let translateX: CGFloat = rect.origin.x + rect.size.width + penaltyCardDrawingPaddingFromMinute
                let translateY: CGFloat = rect.origin.y - (container.height - rect.size.height) / 2.0
                let translateFromCornerToRightPlace = CGAffineTransform(translationX: translateX, y: translateY)
                path.apply(translateFromCornerToRightPlace)
            }
            
            context.saveGState()
            context.setLineWidth(1.0)
            context.setStrokeColor(UIColor.clear.cgColor)
            context.setFillColor(card.color().cgColor)
            
            context.addPath(path.cgPath)
            context.drawPath(using: .fillStroke)
            context.restoreGState()
            
            // Player Name
            let playerParagraphStyle = NSMutableParagraphStyle()
            playerParagraphStyle.alignment = (team == .Home) ? .right : .left
            var playerAttributedString = NSAttributedString()
            var playerRect = CGRect.zero
            let playerAttributes = [NSAttributedString.Key.font: fontForPlayerIndicator, NSAttributedString.Key.paragraphStyle: playerParagraphStyle, NSAttributedString.Key.foregroundColor: UIColor.label]
            
            let playerString = (player == LS_STAFF || player == LS_CAPTAIN) ? player : LS_PLAYER + " " + player
            playerAttributedString = NSAttributedString(string: playerString, attributes: playerAttributes)
            let playerWidth = pageRect.width * 0.25
            if team == .Home {
                let playerX: CGFloat = rect.origin.x - penaltyCardDrawingPaddingFromMinute - container.width - penaltyCardDrawingPaddingFromMinute / 3.0 - playerWidth
                let playerY: CGFloat = rect.origin.y
                playerRect = CGRect(x: playerX, y: playerY, width: playerWidth, height: playerAttributedString.size().height)
            } else {
                let playerX: CGFloat = rect.origin.x + rect.size.width + penaltyCardDrawingPaddingFromMinute + container.width + penaltyCardDrawingPaddingFromMinute / 3.0
                let playerY: CGFloat = rect.origin.y
                playerRect = CGRect(x: playerX, y: playerY, width: playerWidth, height: playerAttributedString.size().height)
            }
            playerAttributedString.draw(in: playerRect)
        }
        
        // Stripe
        let newY = addStripeStart(context: context, pageRect: pageRect, top: rect.origin.y + rect.size.height + penaltyCardVertPadding)
        
        return newY
    }
    
    private func addGoal(_ goal: Goal, homeScore: Int, awayScore: Int, context: CGContext, pageRect: CGRect, top: CGFloat) -> CGFloat {
        
        // Stripe
        let y = addStripeEnd(context: context, pageRect: pageRect, top: top)
        
        // Goal
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let scoreAttributes = [NSAttributedString.Key.font: fontForScoreIndicator, NSAttributedString.Key.paragraphStyle: paragraphStyle, NSAttributedString.Key.foregroundColor: UIColor.white]
        let scoreString = String(homeScore) + " - " + String(awayScore)
        let attributedScoreString = NSAttributedString(string: scoreString, attributes: scoreAttributes)
        let scoreWidth = pageRect.width * 0.4
        let scoreRect = CGRect(x: (pageRect.width - scoreWidth) / 2.0, y: y + penaltyCardVertPadding, width: scoreWidth, height: attributedScoreString.size().height)
        
        context.saveGState()
        let fillColor = UIColor(named: ColorName.DarkBlue)!
        context.setFillColor(fillColor.cgColor)
        context.setLineWidth(1.0)
        context.setStrokeColor(UIColor.clear.cgColor)
        let rrWidth: CGFloat = attributedScoreString.size().width + roundedRectHorInset * 2
        let rrHeight: CGFloat = attributedScoreString.size().height + roundedRectVertInset * 2
        let roundedRect = CGRect(x: (pageRect.width - attributedScoreString.size().width) / 2.0 - roundedRectHorInset, y: y + penaltyCardVertPadding - roundedRectVertInset, width: rrWidth, height: rrHeight)
        let roundedPath = CGPath(roundedRect: roundedRect, cornerWidth: rrHeight / 2.0, cornerHeight: rrHeight / 2.0, transform: nil)
        context.addPath(roundedPath)
        context.drawPath(using: .fillStroke)
        context.restoreGState()
        
        attributedScoreString.draw(in: scoreRect)
        
        // Minute
        let attributes = [NSAttributedString.Key.font: fontForMinuteIndicator, NSAttributedString.Key.paragraphStyle: paragraphStyle, NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel]
        let string = String(goal.inMinute) + "'"
        let attributedString = NSAttributedString(string: string, attributes: attributes)
        let width = pageRect.width * 0.1
        let rect = CGRect(x: (pageRect.width - width) / 2.0, y: scoreRect.origin.y + scoreRect.size.height + goalToMinutePadding, width: width, height: attributedString.size().height)
        attributedString.draw(in: rect)
        
        // Stripe
        let newY = addStripeStart(context: context, pageRect: pageRect, top: rect.origin.y + rect.size.height + penaltyCardVertPadding)
        
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
    
    private func addFooter(context: CGContext, pageRect: CGRect, top: CGFloat) -> CGFloat {
        
        // Line
        context.saveGState()
        context.setLineWidth(footerLineWidth)
        context.setStrokeColor(UIColor.secondaryLabel.cgColor)
        
        let startPoint = CGPoint(x: footerLineInset, y: top)
        let endPoint = CGPoint(x: pageRect.width - footerLineInset, y: top)
        context.move(to: startPoint)
        context.addLine(to: endPoint)
        context.strokePath()
        context.restoreGState()
        
        // Text
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes = [NSAttributedString.Key.font: fontForFooter, NSAttributedString.Key.paragraphStyle: paragraphStyle, NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel]
        var string = LS_GAME_REPORT_FOOTER
        if let startTime = game.startTime {
            string += " - " + dateFormatter.string(from: startTime)
        }
        let attributedString = NSAttributedString(string: string, attributes: attributes)
        let rect = CGRect(x: startPoint.x, y: top + footerLineWidth + footerPadding, width: pageRect.width - startPoint.x * 2.0, height: attributedString.size().height)
        attributedString.draw(in: rect)
        
        return rect.origin.y + rect.size.height + penaltyCardVertPadding
    }
}
