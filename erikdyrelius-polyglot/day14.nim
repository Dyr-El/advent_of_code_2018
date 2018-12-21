from strutils import intToStr, join
from sequtils import toSeq

let
    input = 513401

const
    startingRecipies = @[3, 7]
    elfRecipies = @[0, 1]

proc newRecipies(recipieScore: var seq[int], elves: var seq[int]) =
    var sm = 0
    for elf in elves:
        sm.inc(recipieScore[elf])
    for c in (sm.intToStr()):
        recipieScore.add(int(c) - int('0'))
    for i in 0 .. <elves.len:
        elves[i] = (elves[i] + recipieScore[elves[i]] + 1) mod recipieScore.len

proc compareEnd(recipieScores: seq[int], pattern: seq[int]):int =
    if recipieScores.len >= pattern.len and recipieScores[^pattern.len .. ^1] == pattern:
        result = recipieScores.len - pattern.len
    elif recipieScores.len >= pattern.len + 1 and recipieScores[^(pattern.len+1) .. ^2] == pattern:
        result = recipieScores.len - pattern.len - 1
    else:
        result = -1

proc findTenAfter(nofRecipies: int): string =
    var
        recipieScores = startingRecipies
        elves = elfRecipies
    while recipieScores.len < nofRecipies + 10:
        newRecipies(recipieScores, elves)
    return recipieScores[nofRecipies ..< nofRecipies + 10].join()

proc numberOfRecipiesBefore(pattern: seq[int]) : int =
    var
        recipieScores = startingRecipies
        elves = elfRecipies
    while compareEnd(recipieScores, pattern) < 0:
        newRecipies(recipieScores, elves)
    result = compareEnd(recipieScores, pattern)

proc strToPattern(numberString: string): seq[int] =
    result = @[]
    for c in numberString:
        result.add(int(c)-int('0'))

import unittest

suite "Day 14 part 1":
    test "1:st example (9)":
        check(findTenAfter(9) == "5158916779")
    test "2:nd example (5)":
        check(findTenAfter(5) == "0124515891")
    test "3:rd example (18)":
        check(findTenAfter(18) == "9251071085")
    test "4:th example (2018)":
        check(findTenAfter(2018) == "5941429882")
suite "Day 14 part 2":
    test "1:st example (51589)":
        check(numberOfRecipiesBefore(strToPattern("51589")) == 9)
    test "2:nd example (01245)":
        check(numberOfRecipiesBefore(strToPattern("01245")) == 5)
    test "3:rd example (92510)":
        check(numberOfRecipiesBefore(strToPattern("92510")) == 18)
    test "4:th example (59414)":
        check(numberOfRecipiesBefore(strToPattern("59414")) == 2018)
                                
echo("Day 14, part 1: ", findTenAfter(input))
echo("Day 14, part 2: ", numberOfRecipiesBefore(strToPattern(input.intToStr)))