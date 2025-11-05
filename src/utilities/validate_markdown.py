#!/usr/bin/env python3
"""
Markdown Cheatsheet Validator

This script validates markdown files in the cheatsheets directory to ensure they
follow the required format and structure conventions.

Usage:
    python validate_markdown.py [file_path]
    python validate_markdown.py --all
    python validate_markdown.py --help
"""

import argparse
from pathlib import Path
import re
import sys
from typing import Tuple


class MarkdownValidator:
    """Validates markdown files against cheatsheet standards."""

    def __init__(self, file_path: Path):
        """
        Initialize the validator with a markdown file path.

        Args:
            file_path: Path to the markdown file to validate
        """
        self.file_path = file_path
        self.content = ""
        self.lines = []
        self.errors = []
        self.warnings = []

    def read_file(self) -> bool:
        """
        Read the markdown file content.

        Returns:
            True if file was read successfully, False otherwise
        """
        try:
            with open(self.file_path, 'r', encoding='utf-8') as f:
                self.content = f.read()
                self.lines = self.content.split('\n')
            return True
        except FileNotFoundError:
            self.errors.append(f"File not found: {self.file_path}")
            return False
        except Exception as e:
            self.errors.append(f"Error reading file: {str(e)}")
            return False

    def validate_h1_title(self) -> None:
        """
        Validate that file starts with an H1 title.

        The first non-empty line should be an H1 heading.
        """
        for i, line in enumerate(self.lines):
            if line.strip():
                if not line.startswith('# '):
                    self.errors.append(
                        f"Line {i + 1}: File should start with H1 title (# Title)"
                    )
                elif line.strip() == '#':
                    self.errors.append(
                        f"Line {i + 1}: H1 title is empty"
                    )
                break

    def validate_table_of_contents(self) -> None:
        """
        Validate that file contains a Table of Contents section.

        The TOC should appear early in the document and use proper heading.
        """
        toc_pattern = re.compile(r'^## Table of Contents', re.IGNORECASE)
        has_toc = any(toc_pattern.match(line) for line in self.lines[:20])

        if not has_toc:
            self.warnings.append(
                "No 'Table of Contents' section found in first 20 lines"
            )

    def validate_headings_hierarchy(self) -> None:
        """
        Validate proper heading hierarchy.

        Ensures headings follow proper nesting (H1 -> H2 -> H3, etc.)
        without skipping levels.
        """
        heading_pattern = re.compile(r'^(#{1,6})\s+(.+)')
        previous_level = 0

        for i, line in enumerate(self.lines):
            match = heading_pattern.match(line)
            if match:
                current_level = len(match.group(1))

                if current_level > previous_level + 1 and previous_level > 0:
                    self.warnings.append(
                        f"Line {i + 1}: Heading level skipped "
                        f"(H{previous_level} -> H{current_level})"
                    )

                previous_level = current_level

    def validate_code_blocks(self) -> None:
        """
        Validate code blocks are properly formatted.

        Ensures code blocks use proper fenced syntax with language identifiers.
        """
        in_code_block = False
        code_block_start = -1

        for i, line in enumerate(self.lines):
            if line.startswith('```'):
                if not in_code_block:
                    in_code_block = True
                    code_block_start = i

                    if line.strip() == '```':
                        self.warnings.append(
                            f"Line {i + 1}: Code block without language identifier"
                        )
                else:
                    in_code_block = False

        if in_code_block:
            self.errors.append(
                f"Line {code_block_start + 1}: Unclosed code block"
            )

    def validate_links(self) -> None:
        """
        Validate markdown links are properly formatted.

        Checks for broken link syntax and missing URLs.
        """
        link_pattern = re.compile(r'\[([^\]]+)\]\(([^)]*)\)')

        for i, line in enumerate(self.lines):
            matches = link_pattern.finditer(line)
            for match in matches:
                link_text = match.group(1)
                link_url = match.group(2)

                if not link_text:
                    self.errors.append(
                        f"Line {i + 1}: Empty link text"
                    )

                if not link_url:
                    self.errors.append(
                        f"Line {i + 1}: Empty link URL"
                    )

    def validate_empty_headings(self) -> None:
        """
        Validate that headings are not empty.

        Ensures all heading lines contain actual text content.
        """
        heading_pattern = re.compile(r'^(#{1,6})\s*$')

        for i, line in enumerate(self.lines):
            if heading_pattern.match(line):
                self.errors.append(
                    f"Line {i + 1}: Empty heading found"
                )

    def validate_trailing_whitespace(self) -> None:
        """
        Check for trailing whitespace on lines.

        Trailing whitespace can cause rendering issues in some markdown parsers.
        """
        for i, line in enumerate(self.lines):
            if line != line.rstrip():
                self.warnings.append(
                    f"Line {i + 1}: Trailing whitespace detected"
                )

    def validate_consecutive_blank_lines(self) -> None:
        """
        Check for excessive consecutive blank lines.

        More than 2 consecutive blank lines may indicate formatting issues.
        """
        blank_count = 0

        for i, line in enumerate(self.lines):
            if not line.strip():
                blank_count += 1
                if blank_count > 2:
                    self.warnings.append(
                        f"Line {i + 1}: More than 2 consecutive blank lines"
                    )
            else:
                blank_count = 0

    def validate_list_formatting(self) -> None:
        """
        Validate list formatting consistency.

        Checks for proper list markers and indentation.
        """
        unordered_pattern = re.compile(r'^(\s*)([-*+])\s+(.+)')
        ordered_pattern = re.compile(r'^(\s*)(\d+\.)\s+(.+)')

        for i, line in enumerate(self.lines):
            unordered_match = unordered_pattern.match(line)
            ordered_match = ordered_pattern.match(line)

            if unordered_match:
                indent = unordered_match.group(1)
                if len(indent) % 2 != 0:
                    self.warnings.append(
                        f"Line {i + 1}: Inconsistent list indentation "
                        f"(should be multiples of 2 spaces)"
                    )

            if ordered_match:
                indent = ordered_match.group(1)
                if len(indent) % 2 != 0:
                    self.warnings.append(
                        f"Line {i + 1}: Inconsistent list indentation "
                        f"(should be multiples of 2 spaces)"
                    )

    def validate(self) -> bool:
        """
        Run all validation checks on the markdown file.

        Returns:
            True if validation passed with no errors, False otherwise
        """
        if not self.read_file():
            return False

        self.validate_h1_title()
        self.validate_table_of_contents()
        self.validate_headings_hierarchy()
        self.validate_code_blocks()
        self.validate_links()
        self.validate_empty_headings()
        self.validate_trailing_whitespace()
        self.validate_consecutive_blank_lines()
        self.validate_list_formatting()

        return len(self.errors) == 0

    def get_report(self) -> str:
        """
        Generate a validation report.

        Returns:
            Formatted string containing errors and warnings
        """
        report_lines = []
        report_lines.append(f"\nValidation Report: {self.file_path.name}")
        report_lines.append("=" * 70)

        if not self.errors and not self.warnings:
            report_lines.append("Status: PASSED")
            report_lines.append("No issues found.")
        else:
            if self.errors:
                report_lines.append(f"\nERRORS ({len(self.errors)}):")
                for error in self.errors:
                    report_lines.append(f"  - {error}")

            if self.warnings:
                report_lines.append(f"\nWARNINGS ({len(self.warnings)}):")
                for warning in self.warnings:
                    report_lines.append(f"  - {warning}")

            status = "FAILED" if self.errors else "PASSED (with warnings)"
            report_lines.append(f"\nStatus: {status}")

        report_lines.append("=" * 70)
        return "\n".join(report_lines)


def validate_single_file(file_path: Path) -> bool:
    """
    Validate a single markdown file.

    Args:
        file_path: Path to the markdown file

    Returns:
        True if validation passed, False otherwise
    """
    validator = MarkdownValidator(file_path)
    is_valid = validator.validate()
    print(validator.get_report())
    return is_valid


def validate_all_files(cheatsheets_dir: Path) -> Tuple[int, int, int]:
    """
    Validate all markdown files in the cheatsheets directory.

    Args:
        cheatsheets_dir: Path to the cheatsheets directory

    Returns:
        Tuple of (total_files, passed_files, failed_files)
    """
    md_files = list(cheatsheets_dir.glob("*.md"))

    if not md_files:
        print(f"No markdown files found in {cheatsheets_dir}")
        return 0, 0, 0

    total_files = len(md_files)
    passed_files = 0
    failed_files = 0

    print(f"\nValidating {total_files} markdown files...\n")

    for md_file in sorted(md_files):
        validator = MarkdownValidator(md_file)
        is_valid = validator.validate()

        if is_valid:
            passed_files += 1
            print(f"✓ {md_file.name}: PASSED")
        else:
            failed_files += 1
            print(f"✗ {md_file.name}: FAILED")
            print(validator.get_report())

    print("\n" + "=" * 70)
    print(f"Summary: {passed_files}/{total_files} files passed validation")
    print(f"Failed: {failed_files}")
    print("=" * 70)

    return total_files, passed_files, failed_files


def main():
    """
    Main entry point for the markdown validator.

    Parses command-line arguments and executes validation.
    """
    parser = argparse.ArgumentParser(
        description="Validate markdown cheatsheet files for proper formatting",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  Validate a single file:
    python validate_markdown.py ../cheatsheets/docker.md

  Validate all cheatsheet files:
    python validate_markdown.py --all

  Get help:
    python validate_markdown.py --help
        """
    )

    parser.add_argument(
        'file',
        nargs='?',
        type=str,
        help='Path to the markdown file to validate'
    )

    parser.add_argument(
        '--all',
        action='store_true',
        help='Validate all markdown files in the cheatsheets directory'
    )

    args = parser.parse_args()

    if args.all:
        script_dir = Path(__file__).parent
        cheatsheets_dir = script_dir.parent / 'cheatsheets'

        if not cheatsheets_dir.exists():
            print(f"Error: Cheatsheets directory not found: {cheatsheets_dir}")
            sys.exit(1)

        total, passed, failed = validate_all_files(cheatsheets_dir)
        sys.exit(0 if failed == 0 else 1)

    elif args.file:
        file_path = Path(args.file)

        if not file_path.exists():
            print(f"Error: File not found: {file_path}")
            sys.exit(1)

        if not file_path.suffix == '.md':
            print(f"Error: File is not a markdown file: {file_path}")
            sys.exit(1)

        is_valid = validate_single_file(file_path)
        sys.exit(0 if is_valid else 1)

    else:
        parser.print_help()
        sys.exit(1)


if __name__ == "__main__":
    main()
