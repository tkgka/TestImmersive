//
//  ImmersiveView.swift
//  testImmersive
//
//  Created by 김수환 on 3/3/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            if let immersiveContentEntity = try? await Entity(named: "Immersive", in: realityKitContentBundle) {
                content.add(immersiveContentEntity)

                // Add an ImageBasedLight for the immersive content
                guard let resource = try? await EnvironmentResource(named: "ImageBasedLight") else { return }
                
                var matX = try! await ShaderGraphMaterial(
                    named: "/Root/Stereoscopic/stereoscopicMetrial",
                    from: "Immersive.usda",
                    in: realityKitContentBundle
                )
                
                if let leftImage = UIImage(named: "stereo_left")?.cgImage {
                    guard let texture = try? await TextureResource.generate(
                        from: leftImage,
                        options: TextureResource.CreateOptions.init(semantic: nil)
                    )
                    else {
                        print("error To set Left Image")
                        return
                    }
                    print(texture) // swiftlint:disable:this no_print
                    try! matX.setParameter(name: "leftImage", value: .textureResource(texture))
                }
                
                if let rightImage = UIImage(named: "stereo_right")?.cgImage {
                    guard let texture = try? await TextureResource.generate(
                        from: rightImage,
                        options: TextureResource.CreateOptions.init(semantic: nil)
                    )
                    else {
                        print("error To set Left Image")
                        return
                    }
                    print(texture) // swiftlint:disable:this no_print
                    try! matX.setParameter(name: "rightImage", value: .textureResource(texture))
                }
                
                if let cube = immersiveContentEntity.findEntity(named: "Cube") as? ModelEntity {
                    cube.model?.materials = [matX]
                    
                    print("set up Cude Metrials") // swiftlint:disable:this no_print
                }
                
                let iblComponent = ImageBasedLightComponent(source: .single(resource), intensityExponent: 0.25)
                immersiveContentEntity.components.set(iblComponent)
                immersiveContentEntity.components.set(ImageBasedLightReceiverComponent(imageBasedLight: immersiveContentEntity))
                // Put skybox here.  See example in World project available at
                // https://developer.apple.com/
            }
        }
    }
}

#Preview {
    ImmersiveView()
        .previewLayout(.sizeThatFits)
}
