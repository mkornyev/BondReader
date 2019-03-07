IDENTIFICATION DIVISION.
PROGRAM-ID. BondReader.
ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
        SELECT inFile ASSIGN "sb201712.asc" ORGANIZATION LINE SEQUENTIAL.
        SELECT outFile ASSIGN "outFile.txt" ORGANIZATION LINE SEQUENTIAL.
DATA DIVISION.
FILE SECTION.

FD inFile.                      *> Moving line into temp record
01 InFileRecord.
        02 Series PIC X.
                88 I Value "I".
                88 E Value "E".
                88 N Value "N".
                88 S Value "S".
        02 RYear PIC 9999.
        02 RMonth PIC 99.
        02 IYear PIC 9999.
        02 MonthVal PIC 9999V99 OCCURS 12.

FD outFile.
01 OutFileRecord.
        02 outSeries PIC X.
        02 outRYear PIC 9999.
        02 outRMonth PIC 99.
        02 outIYear PIC 9999.
        02 outMonthVal PIC 9999V99 OCCURS 12.

WORKING-STORAGE SECTION.

01 Max PIC 999V99 Value 1.
01 Min PIC 999V99.

01 firstRun PIC 9 Value 1.
01 inFileCounter PIC 9999999 Value 0.
01 outFileCounter PIC 9999999 Value 0.

01 loopCounter PIC 99.
01 writtenRecord PIC 9 Value 0. *> 0 = NOT Written

01 AVG PIC ZZZZZZZZZZZV99.
01 valSUM PIC 99999999999V99.

PROCEDURE DIVISION.


OPEN INPUT inFile.
OPEN OUTPUT outFile.

PERFORM FOREVER
*>Loops throught every BOND
        READ inFile AT END EXIT PERFORM
        NOT AT END
                *>Initialize Min Val Once (for an accurate comparison!):
                IF firstRun = 1 THEN SUBTRACT 1 FROM firstRun MOVE monthVal(1) to Min END-IF

                PERFORM VARYING loopCounter FROM 1 BY 1 UNTIL loopCounter = 13
                        *>Tracking Min/Max
                        IF monthVal(loopCounter) IS NUMERIC
                                IF Max < MonthVal(loopCounter) THEN MOVE MonthVal(loopCounter) TO Max END-IF
                                IF Min > MonthVal(loopCounter) THEN MOVE MonthVal(loopCounter) TO Min END-IF
                        END-IF
                        *>Writes record ONCE given correct parameters
                        IF writtenRecord = 0  THEN
                                IF (MonthVal(loopCounter) >= 55 AND <= 60) THEN
                                        MOVE inFileRecord to outFileRecord
                                        WRITE outFileRecord
                                        ADD 1 TO outFileCounter
                                        ADD 1 TO writtenRecord
                                END-IF
                        END-IF
                END-PERFORM
                SUBTRACT 1 FROM writtenRecord
                ADD 1 TO inFileCounter
        END-READ
END-PERFORM.

CLOSE inFile.
CLOSE outFile.

OPEN INPUT outFile.

PERFORM FOREVER
*>Loop thru all Bonds in outFile to find the AVG
        READ outFile AT END EXIT PERFORM
        NOT AT END
                PERFORM VARYING loopCounter FROM 1 BY 1 UNTIL loopCounter = 13
                        ADD outMonthVal(loopCounter) TO valSUM
                        Display valSUM
                        *>Gives you sum of all redemption vals in outFile
                END-PERFORM
        END-READ
END-PERFORM.

Display "Max Value: " Max.
Display "Min Value: " Min.
Display "Number of records read for inFile: " inFileCounter.
Display "Number of records read for outFile: " outFileCounter.
MULTIPLY 12 BY outFileCounter.
DIVIDE valSUM BY outFileCounter GIVING AVG.
Display "Average Redemption Value: " AVG.

CLOSE outFile.

STOP RUN.