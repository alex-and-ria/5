import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

ApplicationWindow {
    visible: true
    width: 400
    height: 200
    title: qsTr("rgr")
    ListView{
        id: g_view
        objectName: "mn"
        width: parent.width
        height: parent.height-parent.height*0.1
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: parent.height*0.05
        anchors.leftMargin: parent.width*0.01
        interactive: false
        model: p_model
        delegate: Rectangle{
            id: rect
            width: childrenRect.width
            height: childrenRect.height
            //border.color: "red"
            Label{
                id: curr_lbl
                text: model.modelData.param_nm+'='
            }
            TextInput{
                id: curr_ti
                anchors.left: curr_lbl.right
                text: model.modelData.param_val;
                validator: DoubleValidator{
                    id: curr_validator
                    bottom: model.modelData.l_bound; top: model.modelData.t_bound
                }
                onEditingFinished: {
                    if(model.modelData.param_nm!="dox"){
                        model.modelData.param_val=curr_ti.text;
                    }
                    else{
                        console.log("qml: dox");
                    }
                    console.log("validator: ",curr_ti.text,"parseFloat(getText(0, 20))=",parseFloat(getText(0, 20)));
                }
            }
            Label{
                anchors.left: curr_ti.right
                text: ' '+model.modelData.param_units
            }
        }

    }

    Button{
        text: "load graph1";
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.bottomMargin: parent.height*0.05
        anchors.leftMargin: parent.width*0.01
        MouseArea{
            anchors.fill: parent
            onClicked:{
                console.log("ldr");
                calc.set_points();
                //ldr.source="q1.qml";
            }
        }
    }

  /*  ListView{
        width: 200
            height: 500
            focus: true
            highlight: Component {
                Rectangle {
                   width: 200
                   height: 20
                   color: "red"
                }
            }
        model: p_model
        delegate: Label{


            anchors.left: parent.left;
            color: "black"
            text: model.modelData.param_nm
        }
    }*/


    /*TextInput{
        id: inppfims
        anchors.left: lblphims.right;
        text: calc.pphims/calc.pqe;
        validator: DoubleValidator{bottom: 0.1; top: 4.0}
        onEditingFinished: {
            calc.pphims=parseFloat(getText(0,20))*calc.pqe;
            console.log("getText(0,20)=",getText(0,20)," parseFloat(getText(0,20))=",parseFloat(getText(0,20)));
        }
    }
    Label{
        id: lblphiF;
        text: "phiF=";
    }
    TextInput{
        id: inpphiF
        anchors.left: inppfims.right;
        text: calc.pphiF/calc.pqe;
        validator: DoubleValidator{bottom: 0.7; top: 0.9}
        onEditingFinished: {
            calc.phiF=parseFloat(getText(0,20))*calc.pqe;
            console.log("getText(0,20)=",getText(0,20)," parseFloat(getText(0,20))=",parseFloat(getText(0,20)));
        }
    }*/
    Loader{
        id:ldr;
        anchors.fill: parent;
        Component.onCompleted:{//dubug mode;
            //calc.set_points();
            source="q1.qml";
        }
    }
}
