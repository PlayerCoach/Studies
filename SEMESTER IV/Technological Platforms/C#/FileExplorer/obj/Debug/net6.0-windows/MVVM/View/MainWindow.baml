   M S B A M L   `   `   `  ����G  CFileExplorer, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null?$clr-namespace:FileExplorer.MVVM.ViewFileExplorer.MVVM.View  5   	   '    !FileExplorer.MVVM.View.MainWindow   5   	   W SPresentationCore, Version=6.0.2.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35\ XPresentationFramework, Version=6.0.2.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35e aSystem.Windows.Controls.Ribbon, Version=6.0.2.0, Culture=neutral, PublicKeyToken=b77a5c561934e089R NWindowsBase, Version=6.0.2.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35^ ZWindowsFormsIntegration, Version=6.0.2.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35H 9http://schemas.microsoft.com/winfx/2006/xaml/presentation      5   	   R NSystem.Xaml, Version=6.0.2.0, Culture=neutral, PublicKeyToken=b77a5c561934e089:x,http://schemas.microsoft.com/winfx/2006/xaml     5   	   @d2http://schemas.microsoft.com/expression/blend/2008     5   	   Jmc;http://schemas.openxmlformats.org/markup-compatibility/2006     5   	   6local$clr-namespace:FileExplorer.MVVM.View     5   	   $	��450��5   	   $	��800��6     � Title$  File Explorer��5	   	    � 
ResizeMode$ NoResize=�5
   	    � 	Resources 5       �� MergedDictionaries �� Source8   2FileExplorer.MVVM.View.StringToVisibilityConverter   StringToVisibilityConverter�� 5   
    5      �� 5      $% ../../Themes/ModernToolbar.xaml?�6%   %   &	          5      60   5      .��5      ]� .+�5   
   c� $	��Top=�6     ModernToolbar#��[ 6'   .@�5      o�  c� OverflowMode$ Never=�6   
������ .@�5      m� $
��File��6   $��33��6)    �� TextAlignment$ Center=�64   .@�5      m� $
��Open��6    m� Command 6-   �� *OpenFileCommand+�� 5      m� 5      $
��Exit��6    6-   �� *CloseAppCommand+5      5      5      �� 5    
   $��Bottom=�6   $��20��6,   
�������y�6O   �� *StatusBarText+ �� 	Converter# [  .@�5!      �� .��5"      �� ��6   �� *StatusBarText+5#      5$      � 5'   
   	 � ColumnDefinitions	 5(      �� 5)      $��* �6#   �� 5*      $��2 �6#   �� 5+      $��* �6#   .+�5-      R� -   5        $��FileTree��5-      
������  5.      
 �� 
TargetType �� Triggers P� Property P� Value �� Property �� Value��%�   'Q�       �� 5/      "
 Q�6    50      P� 51       �@Q�
IsSelected$
 True��6<   . �52   "   ��  � ��
 ���� 6?   �� 53   "    � ��
 ���� 6@   54      56      57      58      �� 5:      $��1��6   
���   �6%   �� 5;      $��2��6   $
��Auto=�6+   .��5<      �� -   5        $��FilePreviewTextBlock��5<      5=      5>      5A      5E      