extends Node

func update(rotationalOffsets, userStateInstance, delta):
	var totalOffset = 0
	var rotationalExpectation = {"0":0,"1":0,"2":0,"3":0,"4":0}
	for offset in rotationalOffsets:
		var offsetValue = rotationalOffsets[str(offset)]["offset"]
		totalOffset += offsetValue
	for offset in rotationalOffsets:
		rotationalOffsets[str(offset)]["offset"] -= totalOffset / rotationalOffsets.size()
		if rotationalOffsets[str(offset)]["offset"] > 5 or rotationalOffsets[str(offset)]["offset"] < -5: rotationalExpectation[str(offset)] = rotationalOffsets[str(offset)]["offset"] / 100 * abs(rotationalOffsets[str(offset)]["offset"]) - 5
	var totalExpectation = 0
	var activeSize = 0
	for expectation in rotationalExpectation:
		if rotationalOffsets[str(expectation)]["collided"] == true:
			totalExpectation += rotationalExpectation[str(expectation)]
			activeSize += 1
	var actualExpectation = 0
	if activeSize > 3: actualExpectation = totalExpectation / activeSize
	print("AE:",actualExpectation)
	if abs(actualExpectation) > 1:
		if rotationalOffsets["0"]["offset"] > rotationalOffsets[str(rotationalOffsets.size()-1)]["offset"]:
			print("left")
		elif rotationalOffsets["0"]["offset"] < rotationalOffsets[str(rotationalOffsets.size()-1)]["offset"]:
			print("right")
	pass
