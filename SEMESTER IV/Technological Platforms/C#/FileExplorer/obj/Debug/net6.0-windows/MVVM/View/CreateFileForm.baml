   M S B A M L   `   `   `  ����G  CFileExplorer, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null?$clr-namespace:FileExplorer.MVVM.ViewFileExplorer.MVVM.View  5   	   +    %FileExplorer.MVVM.View.CreateFileForm   5   	   W SPresentationCore, Version=6.0.2.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35\ XPresentationFramework, Version=6.0.2.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35e aSystem.Windows.Controls.Ribbon, Version=6.0.2.0, Culture=neutral, PublicKeyToken=b77a5c561934e089R NWindowsBase, Version=6.0.2.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35^ ZWindowsFormsIntegration, Version=6.0.2.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35H 9http://schemas.microsoft.com/winfx/2006/xaml/presentation      5   	   R NSystem.Xaml, Version=6.0.2.0, Culture=neutral, PublicKeyToken=b77a5c561934e089:x,http://schemas.microsoft.com/winfx/2006/xaml     5   	   @d2http://schemas.microsoft.com/expression/blend/2008     5   	   Jmc;http://schemas.openxmlformats.org/markup-compatibility/2006     5   	   6local$clr-namespace:FileExplorer.MVVM.View     5   	     � Title$  CreateFileForm��5   	   $	��350��6    $	��250��6-    � 
ResizeMode$ NoResize=�69   .��5	      � .+�5
   
   �� $��	File Name��6   $
��Left=�6%   $��	10,18,0,0q�6@   $	��Top=�6S   �� 5   
   -   5        $��FileNameTextBox��5      $
��Left=�6C   $��23��6^   $��
104,18,0,0q�6j    �� TextWrapping$
 Wrap=�6~   $	��Top=�6�   $	��120��6�   ��6)   �� *
FileName+6�   	� 5   
   $
��File��6   $
��Left=�6B   $��	26,81,0,0q�6]   $	��Top=�6p    	� 	GroupName$ FileType��6�    d� 	IsChecked 6%   �� *IsFile+6�   	� 5   
   $��	Directory��6   $
��Left=�6L   $��
157,81,0,0q�6g   $	��Top=�6{   $ FileType��6�    6*   �� *IsDirectory+6�   �� 5   
   $��ReadOnly��6   $��Center=�6G   $��
14,160,0,0q�6d   $	��Top=�6x    6&   �� *
IsReadOnly+6x   �� 5   
   $��Archive��6   $��Center=�6E   $��	2,175,0,0q�6b   $	��Top=�6u    6%   �� *	IsArchive+6u   �� 5   
   $��Hidden��6   $��Center=�6C   $��	2,190,0,0q�6`   $	��Top=�6s    6$   �� *
IsHidden+6s   �� 5   
   $��System��6   $��Center=�6C   $��	1,205,0,0q�6`   $	��Top=�6s    6$   �� *
IsSystem+6s   �� 5   
   $��Create��6   $
��Left=�6�   $��
26,280,0,0q�6�   $	��Top=�6�   $��75��6�   ��6"   �� *CreateCommand+��6D   ��  �� RelativeSource �� *FindAncestor+ �� AncestorType" �6�   �� 5   
   $��Cancel��6   $
��Left=�6�   $��148,280,0,0q�6�   $	��Top=�6�   $��76��6�   ��6"   �� *CancelCommand+��6D   ��  �� *FindAncestor+" �6�   5      5      