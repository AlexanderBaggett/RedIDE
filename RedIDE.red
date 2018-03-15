Red [Needs 'View]

;;keywords: to-block read %keywords.txt this puts the words on different lines
;;keywords: to-block form read/lines %keywords.txt
functions: read %functions.txt
natives: read %natives.txt
types: read %datatypes.txt
events: read %events.txt

;; could also do read/lines %keywords.txt and put each word on it's own line in the file itself.

tab1: [
    below group-box 460x100 "Actions" [
        origin 20x40                     ;;interpret the contents of the area
        button 75x25 "Interpret" on-click [do face/parent/parent/pane/2/text ]                           
        button 75x25 "Compile" on-click [
            print "Compiling"
            write to file! t/data/(t/selected) face/parent/parent/pane/2/text
            either  face/parent/pane/3/data/(face/parent/pane/3/selected) = "Dev" [ ;;use drop down to determine if dev or release
                print "Dev code path" 
                call/wait/shell/output append copy "red.exe -c " t/data/(t/selected) out: copy "" /output
                print out
            ][                                           
                print "release";;here we append .red file extension the the name of the tab
                call/wait/shell/output append copy "red.exe -r " t/data/(t/selected) out: copy "" /output ;;call via commandline
                print out
            ]
        ] 
        drop-down data: ["Dev" "Release"]
        drop-down data: ["MSDOS" "Windows" "WindowsXP" "Linux" "Linux-ARM" "RPi" "Darwin" "Syllable" "FreeBSD" "Android" "Android-x86" ]
    ]
    ;;going to call a function and hightlight the text probably going write over the text using draw, either that or underline it or something.
    a: area 460x400 rate 0:0:3 on-time [
        ;editor/pane/1/pane/1/pane/3/offset: 10x121  ;set overlay to overlap this textarea
;; this is a very naive approach to syntax coloring

;;if it's not blank
       if not-equal? face/text none [


           foreach line split face/text to string! newline [

               firstchar: first line
               if firstchar = ";" [
                   ;a/draw [ text 20x20 reduce [line] ]
                    a/draw [
                    ]

               ]
           ]
       
           { foreach word split face/text " " [
            
                foreach funcword split functions newline [
                    
                    if to string! funcword = word [

                    ]
                ]
                foreach nativeword split natives newline [

                    if to string! nativeword = word [
                        
                    ]
                ]
                foreach eventword split events newline [

                    if to string! eventword = word [
                        
                    ]
                ]
                foreach typeword split types newline [

                    if to string! typeword = word [
                        
                    ]
                ]
            ] 
            }
       ]


    ;;foreach word  split functions newline [
    ;;print word
    ;;]

    ]
    overlay: base 90.90.90.200 460x400 on-down [
       editor/pane/1/pane/1/pane/2/selected: true  ;select the area if the base is clicked on
        ]
]



tabcount: 1

editor: layout compose/deep/only [
    below
    ;;this works but I would prefer to do it via the window
    ;;button "New File" [ append t/data "tab" append t/pane make face! [type: 'panel pane: layout/only tab1] ]
    t: tab-panel 490x570 ["Untitled.red" (tab1) ]
]

editor/menu: [
    "File"  [
        "New"    newfile
        "Rename" newName
        "Load"   loadfile
        "Save"   savefile
        "SaveAs" savefile2
        "Close"  closefile
        "Quit"   leave
    ]
    "Edit" [
        "Change Font" newfont
    ]
] 

editor/actors: make object! [
    on-menu: func [face [object!] event [event!]][
        switch event/picked [
            ;; Copy contents of "tab 1" into every new tab that we create via new file
            newfile   [
                append t/data "newfile.red"
                append t/pane make face! [type: 'panel pane: layout/only tab1]
            ]
            newName   [
                do view [ ;;purpose here is to rename the tab itself
                    name: field button "Done" [
                        t/data/(t/selected): name/text 
                        unview
                    ]
                ]
            ]
            ;;we are updating the value of the active tab's area to contain the contents of the file
            loadfile  [
                print "loading"
                filename: request-file
                read file: filename
                ; 'name now has filename
                ;replace t/pane/(t/selected)/2/text file
                append t/data  last split to string!  filename "/"
                append t/pane make face! [type: 'panel pane: layout/only tab1]
                ;replace t/pane/(t/selected)/2/text file
                t/pane/(t/selected)/pane/2/text: file
            ] ; 
            savefile  [
                print "saving" ;;write the contents of the area to a file using the name of the tab as the filename
                write to file! t/data/(t/selected)  t/pane/(t/selected)/pane/2/text
            ]
            savefile2 [
                print "saving"
                write request-file/save t/pane/(t/selected)/pane/2/text
            ]
            leave [unview]

            newfont [ t/pane/(t/selected)/pane/2/font: request-font ]
            closefile [
                ;remove the selected tab header, and data from both series via exclude
               t/data: exclude t/data reduce [t/data/(t/selected)]
               t/pane: exclude t/pane reduce [t/pane/(t/selected)]
            ]
        ]
    ]
]

editor/text: "Red IDE"
;editor/pane/1/pane/1/pane/3/offset: 10x121 ;set offest of base to be same as area
view/tight editor

;        editor/pane/1/pane/1/pane/3/offset   = offset of base =10x531
; offest of area = 10x121
;editor/pane/1/pane/1/pane/3/offset: 10x121 worked

