const fs = require('fs');
const path = require('path');

// Adjusted to use an absolute path based on your project root directory
const imageDir = path.join(__dirname, '..', 'images'); 
const outputDir = path.join(__dirname, '..', 'metadata'); 

async function generateCid(filePath, ipfs) {
    const content = fs.readFileSync(filePath);
    const { cid } = await ipfs.add(content);
    return cid.toString();
}

async function main() {
    // Ensure the 'images' directory exists
    if (!fs.existsSync(imageDir)) {
        console.error(`Error: Directory ${imageDir} does not exist.`);
        process.exit(1);
    }

    // Ensure the 'metadata' directory exists; if not, create it
    if (!fs.existsSync(outputDir)) {
        fs.mkdirSync(outputDir, { recursive: true });
    }

    const ipfs = await import('ipfs-core').then(ipfs => ipfs.create());

    // Read all files in the image directory
    const imageFiles = fs.readdirSync(imageDir);

    for (let filename of imageFiles) {
        const filepath = path.join(imageDir, filename);
        
        // Generate CID for the image
        const cid = await generateCid(filepath, ipfs);

        // Construct metadata object
        const metadata = {
            name: path.basename(filename, path.extname(filename)),
            description: `An image named ${filename}`,
            image: `https://ipfs.io/ipfs/${cid}`
        };

        // Save metadata to a JSON file
        const outputPath = path.join(outputDir, `${metadata.name}.json`);
        fs.writeFileSync(outputPath, JSON.stringify(metadata, null, 2));

        console.log(`Generated metadata for ${filename} and saved to ${outputPath}`);
    }

    await ipfs.stop();
}

main().catch(error => {
    console.error("An error occurred:", error.message);
});
