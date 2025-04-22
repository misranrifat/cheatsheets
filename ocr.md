# Comprehensive OCR Cheatsheet

## Table of Contents
- [Introduction to OCR](#introduction-to-ocr)
- [Popular OCR Tools](#popular-ocr-tools)
- [Command Line OCR with Tesseract](#command-line-ocr-with-tesseract)
- [OCR Preprocessing Techniques](#ocr-preprocessing-techniques)
- [OCR File Formats](#ocr-file-formats)
- [Programming with OCR](#programming-with-ocr)
- [OCR Best Practices](#ocr-best-practices)
- [Troubleshooting Common OCR Issues](#troubleshooting-common-ocr-issues)
- [Advanced OCR Techniques](#advanced-ocr-techniques)
- [OCR for Different Languages](#ocr-for-different-languages)
- [Vim Commands for OCR Text Editing](#vim-commands-for-ocr-text-editing)

## Introduction to OCR

OCR (Optical Character Recognition) is a technology that converts different types of documents, such as scanned paper documents, PDF files, or images captured by a digital camera, into editable and searchable data.

**Key OCR Concepts**:
- **Text Recognition**: Identifying characters and words in images
- **Layout Analysis**: Understanding document structure (paragraphs, columns, tables)
- **Language Processing**: Applying linguistic rules to improve recognition
- **Machine Learning**: Using AI to improve recognition accuracy

## Popular OCR Tools

### Free/Open Source
- **Tesseract OCR**: Open-source OCR engine sponsored by Google
- **OCRmyPDF**: Adds OCR layer to PDFs
- **EasyOCR**: Python library supporting 80+ languages
- **gImageReader**: GUI for Tesseract
- **OCRFeeder**: Document layout analysis and OCR

### Commercial
- **ABBYY FineReader**: High accuracy, multi-language support
- **Adobe Acrobat Pro**: Built-in OCR for PDFs
- **OmniPage**: Advanced OCR with formatting preservation
- **Microsoft OneNote**: Basic OCR capabilities
- **Google Cloud Vision OCR**: Cloud-based OCR API
- **Amazon Textract**: Document text and data extraction
- **Microsoft Azure Computer Vision**: OCR as a service

## Command Line OCR with Tesseract

### Installation
```bash
# Ubuntu/Debian
sudo apt install tesseract-ocr

# macOS
brew install tesseract

# Windows (using chocolatey)
choco install tesseract
```

### Basic Usage
```bash
# Basic OCR on an image file
tesseract image.png output

# Specify language
tesseract image.png output -l eng+fra

# Output format (text, PDF, hOCR, TSV, etc.)
tesseract image.png output -l eng --oem 1 --psm 3 -c preserve_interword_spaces=1 pdf
```

### Important Tesseract Parameters
```
--oem N         OCR Engine Mode (0-3)
                0 = Legacy engine only
                1 = Neural nets LSTM engine only
                2 = Legacy + LSTM engines
                3 = Default, based on what is available

--psm N         Page Segmentation Mode (0-13)
                0 = Orientation and script detection only
                1 = Automatic page segmentation with OSD
                3 = Fully automatic page segmentation, no OSD (default)
                4 = Assume a single column of text
                6 = Assume a single uniform block of text
                7 = Treat the image as a single text line
                8 = Treat the image as a single word
                10 = Treat the image as a single character
```

## OCR Preprocessing Techniques

Good preprocessing significantly improves OCR accuracy:

### Image Enhancement
```bash
# Using ImageMagick for preprocessing
# Increase contrast
convert input.jpg -contrast output.jpg

# Convert to grayscale
convert input.jpg -colorspace gray output.jpg

# Binarization (black & white)
convert input.jpg -threshold 50% output.jpg

# Noise removal
convert input.jpg -despeckle output.jpg

# Deskew (straighten) an image
convert input.jpg -deskew 40% output.jpg
```

### Python Preprocessing with OpenCV
```python
import cv2
import numpy as np

# Load image
img = cv2.imread('image.jpg')

# Convert to grayscale
gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

# Apply thresholding
_, thresh = cv2.threshold(gray, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)

# Remove noise
denoised = cv2.fastNlMeansDenoising(thresh, None, 10, 7, 21)

# Deskew
# First find the angle
coords = np.column_stack(np.where(denoised > 0))
angle = cv2.minAreaRect(coords)[-1]
if angle < -45:
    angle = -(90 + angle)
else:
    angle = -angle

# Rotate the image to deskew it
(h, w) = denoised.shape[:2]
center = (w // 2, h // 2)
M = cv2.getRotationMatrix2D(center, angle, 1.0)
deskewed = cv2.warpAffine(denoised, M, (w, h), flags=cv2.INTER_CUBIC, borderMode=cv2.BORDER_REPLICATE)

# Save the processed image
cv2.imwrite('processed.jpg', deskewed)
```

## OCR File Formats

### Input Formats
- **Images**: PNG, JPEG, TIFF, GIF, BMP
- **Documents**: PDF, DOCX, XPS
- **Specialized**: DJVU, WebP

### Output Formats
- **Plain Text**: TXT
- **Structured**: HTML, XML, JSON
- **Document**: PDF (searchable), DOCX, RTF
- **Data**: CSV, TSV
- **OCR-specific**: hOCR, ALTO XML, PAGE XML

### hOCR Format Example
```html
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <title>OCR Output</title>
</head>
<body>
  <div class="ocr_page" id="page_1" title="image example.png; bbox 0 0 1200 1800; ppageno 0">
    <div class="ocr_carea" id="block_1_1" title="bbox 100 100 1100 200">
      <p class="ocr_par" id="par_1_1" lang="eng" title="bbox 100 100 1100 200">
        <span class="ocr_line" id="line_1_1" title="bbox 100 100 1100 150; baseline 0 0">
          <span class="ocrx_word" id="word_1_1" title="bbox 100 100 200 150; x_wconf 96">Hello</span>
          <span class="ocrx_word" id="word_1_2" title="bbox 210 100 310 150; x_wconf 95">World</span>
        </span>
      </p>
    </div>
  </div>
</body>
</html>
```

## Programming with OCR

### Python with Tesseract (pytesseract)
```python
import pytesseract
from PIL import Image

# Basic usage
text = pytesseract.image_to_string(Image.open('image.png'))
print(text)

# With language specification
text = pytesseract.image_to_string(Image.open('image.png'), lang='eng+fra')
print(text)

# Get detailed information (bounding boxes, confidence levels)
data = pytesseract.image_to_data(Image.open('image.png'), output_type=pytesseract.Output.DICT)
print(data['text'])  # List of recognized words
print(data['conf'])  # Confidence levels for each word

# Get bounding boxes for text
boxes = pytesseract.image_to_boxes(Image.open('image.png'))
print(boxes)
```

### Python with EasyOCR
```python
import easyocr

# Initialize reader for English and French
reader = easyocr.Reader(['en', 'fr'])

# Basic usage
results = reader.readtext('image.png')

# Extract text only
texts = [result[1] for result in results]
print(texts)

# With confidence threshold
results = reader.readtext('image.png', min_size=10, 
                         width_ths=0.5, height_ths=0.5,
                         slope_ths=0.5, 
                         paragraph=True,
                         detail=0)
print(results)
```

### Node.js with Tesseract.js
```javascript
const { createWorker } = require('tesseract.js');

(async () => {
  const worker = await createWorker('eng');
  
  // Basic usage
  const { data: { text } } = await worker.recognize('image.png');
  console.log(text);
  
  // Get detailed information
  const { data } = await worker.recognize('image.png', { 
    classify_bln_numeric_mode: 0,
    tessedit_pageseg_mode: '3',
  });
  console.log(data);
  
  await worker.terminate();
})();
```

## OCR Best Practices

### Image Quality
- **Resolution**: Minimum 300 DPI (dots per inch) for best results
- **Format**: Lossless formats (PNG, TIFF) preferred over lossy ones (JPEG)
- **Contrast**: Ensure high contrast between text and background
- **Lighting**: Even lighting across the document
- **Clean Images**: Remove artifacts, speckles, and background noise

### Document Preparation
- **Alignment**: Ensure text is properly aligned horizontally
- **Margins**: Adequate margins prevent text cut-off
- **Font Size**: Minimum 10pt font for reliable recognition
- **Font Type**: Standard fonts over decorative ones
- **Spacing**: Adequate spacing between lines and characters

### OCR Workflow
1. **Scan/Capture** high-quality images
2. **Preprocess** images (deskew, denoise, enhance contrast)
3. **Segment** document into meaningful regions
4. **Recognize** text in each region
5. **Post-process** text (spellcheck, grammar correction)
6. **Validate** results against expected patterns
7. **Export** to desired format

## Troubleshooting Common OCR Issues

### Poor Recognition Accuracy
- **Issue**: OCR produces many errors in text recognition
- **Solutions**:
  - Improve image quality and resolution
  - Use appropriate preprocessing techniques
  - Select the correct language and OCR engine
  - Train the OCR system with custom patterns if necessary

### Incorrect Layout Recognition
- **Issue**: Text columns merged, tables misinterpreted
- **Solutions**:
  - Use appropriate page segmentation mode (--psm parameter in Tesseract)
  - Consider specialized OCR software for complex layouts
  - Manually segment the document before OCR

### Missing Characters or Words
- **Issue**: Some text not recognized at all
- **Solutions**:
  - Check image for low contrast areas
  - Adjust threshold values in preprocessing
  - Check for unusual fonts or symbols
  - Try different OCR engines or configurations

### Performance Issues
- **Issue**: OCR processing takes too long
- **Solutions**:
  - Reduce image resolution (but keep above 300 DPI)
  - Split large documents into smaller chunks
  - Use multithreading for batch processing
  - Consider GPU-accelerated OCR solutions

## Advanced OCR Techniques

### Zonal OCR
Extracting text from specific regions of a document:

```python
import pytesseract
from PIL import Image

# Define zones as (left, top, width, height)
zones = [
    (100, 100, 300, 50),  # Zone 1 - Header
    (100, 200, 300, 400),  # Zone 2 - Main content
    (500, 700, 200, 50)    # Zone 3 - Footer
]

image = Image.open('document.png')

# Extract text from each zone
for i, zone in enumerate(zones):
    left, top, width, height = zone
    cropped = image.crop((left, top, left+width, top+height))
    text = pytesseract.image_to_string(cropped)
    print(f"Zone {i+1}:\n{text}\n")
```

### Template Matching
Using templates to extract data from structured documents:

```python
import cv2
import numpy as np
import pytesseract

# Load template and document
template = cv2.imread('template.png', 0)
document = cv2.imread('document.png', 0)

# Find template in document
res = cv2.matchTemplate(document, template, cv2.TM_CCOEFF_NORMED)
min_val, max_val, min_loc, max_loc = cv2.minMaxLoc(res)

# Get coordinates of matching area
top_left = max_loc
h, w = template.shape
bottom_right = (top_left[0] + w, top_left[1] + h)

# Define regions relative to template position
name_region = (top_left[0] + 100, top_left[1] + 50, 300, 30)
date_region = (top_left[0] + 100, top_left[1] + 100, 200, 30)

# Extract data from regions
name_img = document[name_region[1]:name_region[1]+name_region[3], 
                    name_region[0]:name_region[0]+name_region[2]]
date_img = document[date_region[1]:date_region[1]+date_region[3], 
                   date_region[0]:date_region[0]+date_region[2]]

name = pytesseract.image_to_string(name_img)
date = pytesseract.image_to_string(date_img)

print(f"Name: {name}")
print(f"Date: {date}")
```

### OCR with Machine Learning Corrections
Using ML to improve OCR results:

```python
import pytesseract
from PIL import Image
import spacy
from fuzzywuzzy import process

# Load NLP model
nlp = spacy.load("en_core_web_sm")

# Define domain-specific vocabulary (example: medical terms)
domain_vocab = ["diagnosis", "prognosis", "treatment", "medication", "patient"]

# Perform OCR
text = pytesseract.image_to_string(Image.open('medical_report.png'))

# Process with NLP
doc = nlp(text)

# Correct potential errors
corrected_text = []
for token in doc:
    # If the token is not recognized as a valid word
    if token.is_alpha and not token.is_stop and token._.in_vocab == False:
        # Find closest match in domain vocabulary
        match, score = process.extractOne(token.text, domain_vocab)
        if score > 80:  # If match is good enough
            corrected_text.append(match)
        else:
            corrected_text.append(token.text)
    else:
        corrected_text.append(token.text)

corrected = " ".join(corrected_text)
print(corrected)
```

## OCR for Different Languages

### Language Support in Tesseract
```bash
# List available languages
tesseract --list-langs

# Install additional language data (Ubuntu/Debian)
sudo apt install tesseract-ocr-[lang]  # Replace [lang] with language code

# Use multiple languages
tesseract image.png output -l eng+fra+deu  # English, French, German
```

### Languages with Special Considerations

#### Right-to-Left Languages (Arabic, Hebrew)
```bash
# For RTL languages, use specific parameters
tesseract arabic.png output -l ara --psm 6 --dpi 300 -c textord_force_make_prop_words=true
```

#### Asian Languages (Chinese, Japanese, Korean)
```bash
# For Chinese
tesseract chinese.png output -l chi_sim  # Simplified Chinese
tesseract chinese.png output -l chi_tra  # Traditional Chinese

# For Japanese with vertical text
tesseract japanese.png output -l jpn --psm 5  # PSM 5 for vertical text
```

#### Indic Scripts (Hindi, Tamil, etc.)
```bash
# For Hindi
tesseract hindi.png output -l hin --psm 6 -c preserve_interword_spaces=1
```

## Vim Commands for OCR Text Editing

OCR often requires significant post-processing. Here are Vim commands particularly useful for cleaning up OCR text:

### Basic Navigation
```
h, j, k, l     - Move cursor left, down, up, right
w, b           - Move to next/previous word
0, $           - Move to beginning/end of line
gg, G          - Move to beginning/end of file
```

### Search and Replace for OCR Cleanup
```
/pattern        - Search for pattern
:%s/l/I/g       - Replace all lowercase 'l' with uppercase 'I' (common OCR error)
:%s/0/O/g       - Replace all zeros with letter 'O' (common OCR error)
:%s/\d/O/g      - Replace all digits with letter 'O'
:%s/[,:;]//g    - Remove all punctuation
:%s/\s\+/ /g    - Replace multiple spaces with single space
:%s/^\s\+//     - Remove leading whitespace
:%s/\s\+$//     - Remove trailing whitespace
```

### Text Manipulation
```
dd             - Delete line
dw             - Delete word
J              - Join lines (useful for fixing bad line breaks)
gqap           - Reformat paragraph (fix OCR paragraph issues)
:g/^$/d        - Delete all blank lines
:g/pattern/d   - Delete all lines containing pattern
```

### OCR-Specific Vim Macros
```
# Record a macro to fix common OCR errors
qa              - Start recording macro 'a'
:%s/rn/m/g      - Replace 'rn' with 'm' (common OCR error)
:%s/li/h/g      - Replace 'li' with 'h'  (common OCR error)
:%s/rnm/mm/g    - Replace 'rnm' with 'mm'
q               - Stop recording
@a              - Execute macro 'a'
```

### Handling OCR Tables
```
# Convert space-aligned columns to CSV
:%s/\s\{2,}/,/g  - Replace 2+ spaces with comma

# For more complex tables
:set virtualedit=all  - Allow cursor positioning anywhere
```

### Advanced OCR Text Processing
```
# Sort lines (e.g., for OCR'd lists)
:%sort

# Find OCR confidence patterns (if preserved in text)
/\[[\d\.]+\]/

# Remove headers/footers that appear on every page
:g/^Page \d\+$/d
```

---

## Additional Resources

### Official Documentation
- [Tesseract OCR](https://tesseract-ocr.github.io/)
- [ABBYY FineReader](https://www.abbyy.com/finereader/)
- [Google Cloud Vision OCR](https://cloud.google.com/vision/docs/ocr)
- [Amazon Textract](https://aws.amazon.com/textract/)

### Libraries and APIs
- [pytesseract](https://github.com/madmaze/pytesseract)
- [EasyOCR](https://github.com/JaidedAI/EasyOCR)
- [Tesseract.js](https://github.com/naptha/tesseract.js)
- [OCRmyPDF](https://github.com/jbarlow83/OCRmyPDF)

### Training Resources
- [Tesseract Training](https://tesseract-ocr.github.io/tessdoc/Training-Tesseract.html)
- [Fine-tuning OCR Models](https://github.com/tesseract-ocr/tesstrain)

### OCR Datasets
- [MNIST](http://yann.lecun.com/exdb/mnist/) - Handwritten digits
- [IAM Handwriting Database](https://fki.tic.heia-fr.ch/databases/iam-handwriting-database)
- [ICDAR Competition Datasets](https://icdar.org/)
