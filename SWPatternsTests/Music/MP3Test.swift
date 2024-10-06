//
//  AudioPlayerManagerTests.swift
//  SWPatternsTests
//
//  Created by Juan Carlos Rubio Casas on 6/10/24.
//

import XCTest
@testable import SWPatterns

final class AudioPlayerManagerTests: XCTestCase {

    var audioPlayerManager: AudioPlayerManager!

    override func setUp() {
        super.setUp()
        // Obtén la instancia compartida del AudioPlayerManager antes de cada prueba.
        audioPlayerManager = AudioPlayerManager.shared
    }

    override func tearDown() {
        // Detén la música después de cada prueba.
        audioPlayerManager.stopMusic()
        audioPlayerManager = nil
        super.tearDown()
    }

    // Test para verificar que la música comienza a reproducirse correctamente.
    func testPlayMusicStarts() {
        // Llamamos a playMusic para iniciar la música.
        audioPlayerManager.playMusic()

        // Verifica que el audioPlayer no sea nil después de iniciar la música.
        XCTAssertNotNil(audioPlayerManager.audioPlayer, "El audioPlayer debería estar inicializado después de llamar a playMusic")

        // Verifica que la música esté reproduciéndose.
        XCTAssertTrue(audioPlayerManager.audioPlayer?.isPlaying ?? false, "La música debería estar reproduciéndose")
    }

    // Test para verificar que la música se detiene correctamente.
    func testStopMusicStops() {
        // Llamamos a playMusic para iniciar la música y luego a stopMusic para detenerla.
        audioPlayerManager.playMusic()
        audioPlayerManager.stopMusic()

        // Verifica que el audioPlayer sea nil después de detener la música.
        XCTAssertNil(audioPlayerManager.audioPlayer, "El audioPlayer debería ser nil después de llamar a stopMusic")
    }
}
