# Get the current directory of the script
$scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path

# Get all left input files matching the LDATE_NUMBER format
$leftFiles = Get-ChildItem -Path $scriptDirectory -Filter "L*.mp4"

foreach ($leftFile in $leftFiles) {
    # Extract DATE_TIME part from the left input file name
    $dateTime = [System.IO.Path]::GetFileNameWithoutExtension($leftFile.Name) -replace "^L"

    # Construct the corresponding right input file
    $rightFileName = "R$($dateTime).mp4"
    $rightFile = Join-Path -Path $scriptDirectory -ChildPath $rightFileName

    $outputFileName = "SBS$($dateTime).mp4"

    if (Test-Path $rightFile) {
        # Stack left and right files horizontally into the output file
        ffmpeg -i $leftFile -i $rightFile -filter_complex "[0:v][1:v]hstack=inputs=2[v]" -map "[v]" -codec:a copy $outputFileName
    }
}
