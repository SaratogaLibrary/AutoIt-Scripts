Func _Draw_Graph()
;----- Set line color and size -----
_GraphGDIPlus_Set_PenColor($Graph,0xFF325D87)
_GraphGDIPlus_Set_PenSize($Graph,2)

;----- draw lines -----
$First = True
_GraphGDIPlus_DrawText($Graph, "Gamma Function in real time", 0, 0)
For $i = -5 to 5 Step 0.05
$y = _GammaFunction($i)
If $First = True Then _GraphGDIPlus_Plot_Start($Graph,$i,$y)
$First = False
_GraphGDIPlus_Plot_Line($Graph,$i,$y)
_GraphGDIPlus_Refresh($Graph)
Next
EndFunc

_Draw_Graph();