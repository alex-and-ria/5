import QtQuick 2.0
import QtCharts 2.2

Item {
    width: 480
    height: 200
    visible: true
    Rectangle{width: parent.width; height: parent.height; color: "white"}//clearing background;
    property var points: 0
    ChartView {
        title: "Vth(Nsub); dox=const"
        objectName: "graph1"
        width: parent.width
        height: parent.height*0.9
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 0
        anchors.leftMargin: 0
        antialiasing: true
        legend.alignment: Qt.AlignBottom
        ValueAxis {
            id: axisX
            min: getbnd(0,0)
            max: getbnd(1,0);
        }
        ValueAxis {
            id: axisY
            min: getbnd(0,1);
            max: getbnd(1,1);
        }
        SplineSeries {
            id: graph_Vth
            objectName: "g1_series"
            name: "Vth"
            axisX: axisX
            axisY: axisY
            onHovered: {
                console.log("onHovered: " + point.x + ", " + point.y, 'st=',state);
                if(state){
                    txtftst.text="x="+point.x+"\ty="+point.y;
                }
            }
            //XYPoint { x: 0; y: 0 }
            //XYPoint { x: 1.1; y: 2.1 }
        }
    }
    Component.onCompleted: {
        //graph_Vth.append(calc.g1_points);
        if(points==0)
            points=calc.g1_points;
        //console.log(points);
        //console.log(points[0]);
        for(var i=0;i<points.length/2;i++){
            console.log(i,' ',points[2*i],' ', points[2*i+1]);
            graph_Vth.append(points[2*i],points[2*i+1]);
        }
    }

    Rectangle{
        width: parent.width/2
        height: parent.height*0.1;
        anchors.bottom: parent.bottom
        color: "white"
        border.color: "black"
        Text {
            id: txtftst
            text: qsTr("txt")
        }
    }
    function getbnd(flmax,flpos){
        if(points==0)
            points=calc.g1_points;
        var retval=points[flpos];
        for(var i=0;i<points.length/2;i++){
            if(flmax&&points[2*i+flpos]>retval){
                retval=points[2*i+flpos];
            }
            else if(!flmax&&points[2*i+flpos]<retval){
                retval=points[2*i+flpos];
            }
            console.log('getbnd ::',i,' ',2*i+flpos,points[2*i+flpos])
        }
        console.log("getbnd: ",retval,' ',flpos)
        return retval;
    }
}
