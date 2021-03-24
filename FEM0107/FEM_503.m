function varargout = FEM_503(varargin)  %����GUI��ʼ

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

function FEM_503_OpeningFcn(hObject, ~, handles, varargin)  %����GUI����
handles.output = hObject;
guidata(hObject, handles);
axes1_CreateFcn;
set(handles.axes1,'visible','off')

function varargout = FEM_503_OutputFcn(~, ~, handles) 
varargout{1} = handles.output;


function Calculate_Callback(hObject,eventdata,handles)  %ģ�ͼ��㰴ť������Ժ�ʼ������Ӧ����
    
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

function SorE_SelectionChangeFcn(hObject,eventdata,handles) %��ѡ��ѡ��ƽ��Ӧ������ƽ��Ӧ��

    global opt COP

    COP=get(hObject,'String');
    switch COP
        case 'Strain'
            opt=1;
        case 'Stress'
            opt=2;
    end

function Gauss_SelectionChangeFcn(hObject, ~, ~)    %��˹���ֵ���Ŀѡ��2�����3��

    global  int

    GOP=get(hObject,'String');

    switch GOP
        case '2���˹����'
            int=2;
        case '3���˹����'
            int=3;
    end
    
function ETC1_SelectionChangeFcn(hObject, eventdata, handles) %�Ȳε�Ԫ��Ŀѡ��

    global element_option
    echoice=get(hObject,'String');

    switch echoice
        case '4��㵥Ԫ'
            element_option=1;
        case '8��㵥Ԫ'
            element_option=2;
    end

function Outcome_SelectionChangeFcn(hObject,eventdata,handles)    %��ȡ���ƽ��ͼ����

    global  iStress
    caseStress=get(hObject,'String');
     switch caseStress
            case 'x������Ӧ��'
                iStress=1;
            case 'y������Ӧ��'
                iStress=2;
            case 'xy������Ӧ��'
                iStress=3;
            case 'x����λ��'
                iStress=4;
            case 'y����λ��'
                iStress=5;
     end
 
function output_Callback(hObject,eventdata, handles)   %ȷ�ϻ����ͼ��

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

function EXIT_Callback(~, ~, handles) %�˳�����ť
    delete(handles.figure1);    
    clc;
    clear all;

function axes1_CreateFcn(~, ~, ~) %��ʾͼƬ������ 
function ETC1_CreateFcn(hObject, eventdata, handles)
