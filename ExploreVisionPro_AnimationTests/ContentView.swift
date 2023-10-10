//
//  ContentView.swift
//  ExploreVisionPro_AnimationTests
//
//  Created by Carlyn Maw on 10/10/23.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    @State var enlarge = false

    var body: some View {
        VStack {
            //A ModelEntity, not expected to autoplay
            Model3D(named: "cube_purple_autoplay", bundle: realityKitContentBundle)
            //An Entity, kinda expected this to autoplay
            RealityView { content in
                if let cube = try? await Entity(named: "cube_purple_autoplay", in: realityKitContentBundle) {
                    print(cube.components)
                    content.add(cube)
                }
            }
//            RealityView { content in
//                if let cube = try? await Entity(named: "Scene_3", in: realityKitContentBundle) {
//                    print(cube.components)
//                    content.add(cube)
//                }
//            }
            //Scene has one cube that should auto play, one that should not.
            //Neither do, but both will start (as expected) with click.
            RealityView { content in
                // Add the initial RealityKit content
                if let scene = try? await Entity(named: "Scene", in: realityKitContentBundle) {
                    content.add(scene)
                }
            } update: { content in
                // Update the RealityKit content when SwiftUI state changes
                if let scene = content.entities.first {
                    
                    if enlarge {
                        for animation in scene.availableAnimations {
                            scene.playAnimation(animation.repeat())
                        }
                    } else {
                        scene.stopAllAnimations()
                    }
                    let uniformScale: Float = enlarge ? 1.4 : 1.0
                    scene.transform.scale = [uniformScale, uniformScale, uniformScale]
                }
                
               
            }
            .gesture(TapGesture().targetedToAnyEntity().onEnded { value in
                print(value.entity) //who was tapped. 
                enlarge.toggle()
            })

            VStack {
                Toggle("Enlarge RealityView Content", isOn: $enlarge)
                    .toggleStyle(.button)
            }.padding().glassBackgroundEffect()
        }
    }
}

#Preview {
    ContentView()
}
