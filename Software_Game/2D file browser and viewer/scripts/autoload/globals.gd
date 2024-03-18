extends Node

var pinned=[
	["SBS Videos", "E:/OneDrive - University of Southampton/COURSES/Y3/COMP3200 Individual Project/Software_Processing/Combined-pipeline"],
	["8 March output", "E:/OneDrive - University of Southampton/COURSES/Y3/COMP3200 Individual Project/Software_Processing/Combined-pipeline/Samples-testing-8-march/output"]
	#["Documents", OS.SYSTEM_DIR_DOCUMENTS],
	#["Desktop", OS.SYSTEM_DIR_DESKTOP],
	#["Downloads", OS.SYSTEM_DIR_DOWNLOADS],
	#["Pictures", OS.SYSTEM_DIR_PICTURES],
	#["Movies", OS.SYSTEM_DIR_MOVIES]
]

#for indexing next/previous button
var file_list = []

signal play
signal stop 
signal pause
