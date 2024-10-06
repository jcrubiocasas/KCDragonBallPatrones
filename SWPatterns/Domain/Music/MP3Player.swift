//
//  MP3Player.swift
//  SWPatterns
//
//  Created by Juan Carlos Rubio Casas on 6/10/24.
//

import AVFoundation

// MARK: - AudioPlayerManager
// Esta clase administra la reproducción de música utilizando `AVAudioPlayer`.
// Implementa el patrón singleton para asegurarse de que solo haya una instancia de `AudioPlayerManager`.
// Proporciona métodos para reproducir y detener música, configurando la sesión de audio adecuadamente.
class AudioPlayerManager {
    
    // Instancia singleton de `AudioPlayerManager`, accesible desde cualquier parte de la aplicación.
    static let shared = AudioPlayerManager()
    
    // Propiedad privada que almacena la instancia de `AVAudioPlayer` que gestiona la reproducción de audio.
    private var audioPlayer: AVAudioPlayer?
    
    // Inicializador privado para evitar que se creen nuevas instancias fuera de la clase (singleton).
    private init() {}
    
    // MARK: - playMusic
    // Método que inicia la reproducción de música de forma continua, configurando la sesión de audio en modo de reproducción.
    func playMusic() {
        // Configura la sesión de audio en modo reproducción.
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            // Si hay un error al configurar la sesión de audio, se imprime un mensaje de error y se detiene el proceso.
            print("Error al configurar la sesión de audio: \(error.localizedDescription)")
            return
        }
        
        // Intenta obtener la URL del archivo de música DragonBall.mp3 desde el bundle principal.
        guard let url = Bundle.main.url(forResource: "DragonBall", withExtension: "mp3") else {
            print("No se encontró el archivo DragonBall.mp3")
            return
        }
        
        // Intenta inicializar el reproductor de audio con el archivo de música encontrado.
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.numberOfLoops = -1  // Configura la música para que se repita de manera infinita.
            audioPlayer?.play()  // Inicia la reproducción de la música.
            print("Reproduciendo música...")
        } catch {
            // Si hay un error al reproducir la música, se imprime un mensaje de error.
            print("Error al reproducir música: \(error.localizedDescription)")
        }
    }
    
    // MARK: - stopMusic
    // Método que detiene la reproducción de la música y libera los recursos asociados al reproductor de audio.
    func stopMusic() {
        audioPlayer?.stop()  // Detiene la reproducción de la música.
        audioPlayer = nil  // Libera la instancia del reproductor de audio.
        print("Música detenida.")
    }
}
