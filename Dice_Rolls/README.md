# Dice Rolls

This script allows users to simulate dice rolls, ideal for tabletop role-playing games like Dungeons & Dragons. Beyond just simple 6-sided dice, it supports a variety of dice, including e.g. 8-sided, 20-sided, and more.
Table of Contents

- Description
- Usage
- Examples

## Description

The roll.sh script rolls dice according to the provided guidelines:

    Arguments define the number of rolls and the type of dice to be rolled.
    The roll count and the number of sides are divided by a hyphen.
    The script can take an arbitrary number of roll arguments.
    The output displays the result of each roll and the total sum of roll values per dice.

## Usage

To use the script:

```bash

./roll.sh [ROLLS]

```
Where [ROLLS] specifies the number and type of dice rolls, e.g., 1-6 for one roll of a 6-sided die.
Examples

    To roll a standard 6-sided die once:

```bash

./roll.sh 1-6
```
    To roll a 6-sided die once, an 8-sided die three times, and a 20-sided die twice:

```bash

./roll.sh 1-6 3-8 2-20
```
## Prerequisites

Ensure the script is executable:

```bash

chmod +x roll.sh

```