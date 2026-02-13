// Run this script to update the photos list
// Usage: node generate-photos.js
const fs = require('fs');
const path = require('path');

const photosDir = path.join(__dirname, 'assets', 'photos');
const outputFile = path.join(__dirname, 'assets', 'photos.json');

// Get all image files
const extensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp'];
const files = fs.readdirSync(photosDir)
  .filter(file => extensions.includes(path.extname(file).toLowerCase()))
  .sort(); // Sort alphabetically

fs.writeFileSync(outputFile, JSON.stringify(files, null, 2));
console.log(`Generated photos.json with ${files.length} images`);
