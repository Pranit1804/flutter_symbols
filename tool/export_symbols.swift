#!/usr/bin/env swift

/// SF Symbols Exporter
/// Renders each SF Symbol as a high-resolution PNG using NSImage(systemSymbolName:)
/// Outputs to tool/pngs/ for subsequent vtracer → SVG → fantasticon pipeline.

import Foundation
import AppKit

// MARK: - Configuration

let plistPath = "/Applications/SF Symbols.app/Contents/Resources/Metadata/name_availability.plist"
let scriptDir = URL(fileURLWithPath: CommandLine.arguments[0]).deletingLastPathComponent()
let outputDir  = scriptDir.appendingPathComponent("pngs")
let manifestPath = scriptDir.appendingPathComponent("symbol_manifest.json")

let renderPointSize: CGFloat = 100.0
let renderScale: CGFloat     = 6.0   // 6x = ~600px, plenty of detail for tracing

// MARK: - Locale-variant filter

let localeSuffixes = [
    ".ar", ".he", ".hi", ".ja", ".ko", ".th", ".zh", ".bn",
    ".gu", ".kn", ".ml", ".mr", ".or", ".pa", ".ta", ".te",
    ".si", ".km", ".my", ".el", ".ru", ".uk", ".am", ".lo",
]
func isLocaleVariant(_ name: String) -> Bool {
    localeSuffixes.contains { name.hasSuffix($0) }
}

// MARK: - Safe filename (replace . with _ for filesystem + fantasticon compat)

func safeFilename(for name: String) -> String {
    name.replacingOccurrences(of: ".", with: "_")
        .replacingOccurrences(of: "/", with: "_")
}

// MARK: - Render symbol to PNG

func renderSymbol(_ name: String, to url: URL) -> Bool {
    guard let nsImage = NSImage(systemSymbolName: name, accessibilityDescription: nil) else {
        return false
    }
    let config = NSImage.SymbolConfiguration(pointSize: renderPointSize, weight: .regular)
    guard let img = nsImage.withSymbolConfiguration(config) else { return false }

    let sz   = img.size
    let pixW = Int(sz.width  * renderScale)
    let pixH = Int(sz.height * renderScale)
    guard pixW > 0, pixH > 0 else { return false }

    guard let bitmapRep = NSBitmapImageRep(
        bitmapDataPlanes: nil,
        pixelsWide: pixW, pixelsHigh: pixH,
        bitsPerSample: 8, samplesPerPixel: 4,
        hasAlpha: true, isPlanar: false,
        colorSpaceName: .calibratedRGB,
        bytesPerRow: 0, bitsPerPixel: 0
    ) else { return false }
    bitmapRep.size = sz

    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmapRep)
    NSColor.white.setFill()
    NSRect(x: 0, y: 0, width: sz.width, height: sz.height).fill()
    img.draw(at: .zero, from: .zero, operation: .sourceOver, fraction: 1.0)
    NSGraphicsContext.restoreGraphicsState()

    guard let pngData = bitmapRep.representation(using: .png, properties: [:]) else { return false }
    do {
        try pngData.write(to: url, options: .atomic)
        return true
    } catch {
        return false
    }
}

// MARK: - Load symbol names

guard let plistData = NSDictionary(contentsOfFile: plistPath),
      let symbolsDict = plistData["symbols"] as? [String: Any] else {
    fputs("Error: cannot read plist at \(plistPath)\n", stderr)
    exit(1)
}

let allNames = Array(symbolsDict.keys).sorted()
let filteredNames = allNames.filter { !isLocaleVariant($0) }

let testMode = CommandLine.arguments.contains("--test")
let namesToProcess = testMode ? Array(filteredNames.prefix(20)) : filteredNames

print("Total symbols: \(allNames.count), after locale filter: \(filteredNames.count)")
print(testMode ? "TEST MODE: processing first 20" : "Full export: \(namesToProcess.count) symbols")

// MARK: - Create output directory

try! FileManager.default.createDirectory(at: outputDir, withIntermediateDirectories: true)

// MARK: - Export loop

var manifest: [String: String] = [:]  // original_name → safe_filename (no extension)
var successCount = 0
var failCount    = 0

for (index, name) in namesToProcess.enumerated() {
    if index > 0 && index % 500 == 0 {
        print("Progress: \(index)/\(namesToProcess.count) (\(successCount) ok, \(failCount) failed)")
    }

    let filename = safeFilename(for: name)
    let pngURL   = outputDir.appendingPathComponent("\(filename).png")

    if renderSymbol(name, to: pngURL) {
        manifest[name] = filename
        successCount  += 1
    } else {
        failCount += 1
    }
}

print("\nExport complete: \(successCount) succeeded, \(failCount) failed")

// MARK: - Write manifest

let manifestData = try! JSONSerialization.data(
    withJSONObject: manifest,
    options: [.prettyPrinted, .sortedKeys]
)
try! manifestData.write(to: manifestPath)
print("Manifest → \(manifestPath.path)")
print("PNGs     → \(outputDir.path)")
