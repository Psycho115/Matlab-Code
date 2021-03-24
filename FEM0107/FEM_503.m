function varargout = FEM_503(varargin)  %程序GUI初始

    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @FEM_503_OpeningFcn, ...
                       'gui_OutputFcn',  @FEM_503_OutputFcn, ...
                       'gui_LayoutFcn',  [] , ...
                       'gui_Callback',   []);
    if nargin && ischar(varargin{1})
        gui_State.gui_Callback = str2func(varargin{1});
    end

    if nargout
        [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
    else
        gui_mainfcn(gui_State, varargin{:});
    
   end

function FEM_503_OpeningFcn(hObject, ~, handles, varargin)  %生成GUI界面
handles.output = hObject;
guidata(hObject, handles);
axes1_CreateFcn;
set(handles.axes1,'visible','off')

function varargout = FEM_503_OutputFcn(~, ~, handles) 
varargout{1} = handles.output;


function Calculate_Callback(hObject,eventdata,handles)  %模型计算按钮，点击以后开始计算相应例题
    
global element_option fj
    ETC1_SelectionChangeFcn(hObject, eventdata, handles);
    SorE_SelectionChangeFcn(hObject,eventdata,handles);
    Gauss_SelectionChangeFcn(hObject,eventdata,handles);    
    fj=0;
    switch element_option
        case 1
            FemModel ;
            handles.axes1;
            cla(handles.axes1);
            colorbar( 'hide' );
            DisplayModel ; 
            SolveModel ;
            DisplayResults ;
        case 2
            FemModel8 ; 
            handles.axes1;
            cla(handles.axes1);
            colorbar( 'hide' );
            DisplayModel ; 
            SolveModel8 ;
            DisplayResults ; 
    end

function SorE_SelectionChangeFcn(hObject,eventdata,handles) %单选框，选择平面应力或者平面应变

    global opt COP

    COP=get(hObject,'String');
    switch COP
        case 'Strain'
            opt=1;
        case 'Stress'
            opt=2;
    end

function Gauss_SelectionChangeFcn(hObject, ~, ~)    %高斯积分点数目选择，2点或者3点

    global  int

    GOP=get(hObject,'String');

    switch GOP
        case '2点高斯积分'
            int=2;
        case '3点高斯积分'
            int=3;
    end
    
function ETC1_SelectionChangeFcn(hObject, eventdata, handles) %等参单元数目选择

    global element_option
    echoice=get(hObject,'String');

    switch echoice
        case '4结点单元'
            element_option=1;
        case '8结点单元'
            element_option=2;
    end

function Outcome_SelectionChangeFcn(hObject,eventdata,handles)    %读取绘制结果图类型

    global  iStress
    caseStress=get(hObject,'String');
     switch caseStress
            case 'x方向正应力'
                iStress=1;
            case 'y方向正应力'
                iStress=2;
            case 'xy方向切应力'
                iStress=3;
            case 'x方向位移'
                iStress=4;
            case 'y方向位移'
                iStress=5;
     end
 
function output_Callback(hObject,eventdata, handles)   %确认画结果图像

    global element_option fj
    Outcome_SelectionChangeFcn(hObject,eventdata,handles)
    handles.axes1;
    cla(handles.axes1);
    switch element_option
        case 1
            PlotStress;
        case 2
            PlotStress8;
    end
    if fj==0
       winopen('result.txt');
       fj=fj+1;
    end

function EXIT_Callback(~, ~, handles) %退出程序按钮
    delete(handles.figure1);    
    clc;
    clear all;

function axes1_CreateFcn(~, ~, ~) %显示图片的区域 
function ETC1_CreateFcn(hObject, eventdata, handles)
