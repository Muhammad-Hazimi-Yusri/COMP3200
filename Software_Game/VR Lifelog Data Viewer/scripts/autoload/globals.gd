extends Node

var pinned=[
	#["SBS Videos", "E:/OneDrive - University of Southampton/COURSES/Y3/COMP3200 Individual Project/Software_Processing/Combined-pipeline"],
	#["8 March output", "E:/OneDrive - University of Southampton/COURSES/Y3/COMP3200 Individual Project/Software_Processing/Combined-pipeline/Samples-testing-8-march/output"],
	["SAMPLES", "res://samples"],
	["Main Drive", str(DirAccess.get_drive_name(0))],
	["2nd Drive", str(DirAccess.get_drive_name(1))],
	["3rd Drive", str(DirAccess.get_drive_name(2))]
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
