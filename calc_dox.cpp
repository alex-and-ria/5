#include "calc_dox.h"

calc_dox::calc_dox(QList<QObject *> &in_dataList, QQmlContext* cntxt, QObject* parent){
    Q_UNUSED(parent); //Q_UNUSED(in_dataList);
    phims=0.1;//*qe;//phi metal_semiconductor; 1eV= 1*qV;
    phiF=0.7;//*qe;//Fermi level for n-type semiconductor;
    qox=0;//q_oxide;
    eox=3.85;//e_oxide;
    esub=11.7;//e_sub;
    Nsub=1e-14;//sm^(-3);
    Vsub=0;//V;
    Vth=0.7;//V;
    connect(this,&calc_dox::doxChanged,this,&calc_dox::ondoxCgd);
    set_model(/*in_dataList*/);
    in_dataList=dataList;
    for(unsigned int i=0;i<dataList.size()-1;i++){
        connect(qobject_cast<data_vars*> (dataList.at(i)), &data_vars::param_valChanged,
                this,&calc_dox::calc);
    }
    qml_cntxt=cntxt;
    cnt=0;
}

void calc_dox::calc(){
    qDebug()<<Q_FUNC_INFO;
    qb=sqrt(2*qe*esub*e0*Nsub*(Vsub+phiF*qe));
    dox=-((Vth-phims*qe-2*phiF*qe)*eox*e0)/(qb+qox);
    emit doxChanged(dox);
}

void calc_dox::set_model(/*QList<QObject *> &dataList*/){
    dataList.append(new data_vars("phims",phims,0.1,4,"eV"));
    dataList.append(new data_vars("phiF",phiF,0.7,0.9,"eV"));
    dataList.append(new data_vars("eox",eox,1.0,2000.0,""));
    dataList.append(new data_vars("esub",esub,1.0,2000.0,""));
    dataList.append(new data_vars("Nsub",Nsub,1.e-16,1.e-14,"sm^(-3)"));
    dataList.append(new data_vars("Vsub",Vsub,0.,10.,"V"));
    dataList.append(new data_vars("dox",dox,dox,dox,"sm"));
}

void calc_dox::ondoxCgd(double ndox){
    qDebug()<<Q_FUNC_INFO<<" dox="<<ndox; cnt++;
    delete dataList.takeLast();
    dataList.append(new data_vars("dox",cnt,ndox,ndox,"sm"));
    qml_cntxt->setContextProperty("p_model", QVariant::fromValue(dataList));
}

