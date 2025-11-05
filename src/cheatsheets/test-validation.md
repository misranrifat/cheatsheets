 Test Validation File

This file intentionally contains multiple validation errors for testing purposes.

## Table of Contents
- [Section 1](#section-1)
- [Section 2](#section-2)
- [Section 3](#section-3)

## Section 1

This section has some content with trailing whitespace at the end.

### Code Examples

Here's a code block without language identifier:
```
def example():
    print("Missing language identifier")
```

And here's a properly formatted one:
```python
def proper_example():
    print("With language identifier")
```

##### Subsection 1.1.1

This heading jumps from H3 to H5, skipping H4.

## Section 2

This section contains an unclosed code block:
```javascript
function unclosedBlock() {
    console.log("This code block is never closed");
    return true;




Multiple blank lines above (more than 2 consecutive).

### Links with Issues

Here are some problematic links:
- [Empty URL link]()
- [](https://example.com)
- [Valid link](https://example.com)

##

Empty heading above this line.

### Lists with Bad Indentation

-  Item 1 (1 space before dash)
  - Item 2 (correct: 2 spaces)
   - Item 3 (3 spaces - odd indentation)
    - Item 4 (4 spaces - even but not multiple of 2 for first level)

## Section 3

### More trailing whitespace
This line ends with spaces.
And this one too.

#

Another empty heading (just H1 marker).

### End of File
