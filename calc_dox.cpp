#include<QFile>
#include "calc_dox.h"

calc_dox::calc_dox(QList<QObject *> &in_dataList, QQmlApplicationEngine* p_engine, QObject* parent){
    Q_UNUSED(parent); //Q_UNUSED(in_dataList);
    phims=new double; *phims=0.1;//*qe;//phi metal_semiconductor; 1eV= 1*qV;
    phiF=new double; *phiF=0.7;//*qe;//Fermi level for n-type semiconductor;
    qox=new double; *qox=0;//q_oxide;
    eox=new double; *eox=3.85;//e_oxide;
    esub=new double; *esub=11.7;//e_sub;
    Nsub=new double; *Nsub=1e14;//sm^(-3);
    Vsub=new double; *Vsub=0.1;//V;
    Vth=new double; *Vth=0.7;//V;
    dox=new double; *dox=0;
    qb=new double; *qb=0;
    connect(this,&calc_dox::doxChanged,this,&calc_dox::ondoxCgd);
    set_model(/*in_dataList*/);
    in_dataList=dataList;
    for(unsigned int i=0;i<(unsigned int)dataList.size()-1;i++){
        connect(qobject_cast<data_vars*> (dataList.at(i)), &data_vars::param_valChanged,
                this,&calc_dox::calc);
    }
    qml_cntxt=(p_engine->rootContext());
    //qml_obj1=p_qml_obj1;
    cnt=0;
    num_points=50; m_m_list=new list_model(num_points+1);//from 0 to num_points it is num_points+1 points;
    calc();
    set_points();
    pm_engine=p_engine;
}

void calc_dox::calc(){
    //*qb=sqrt(2*qe*(*esub)*e0*(*Nsub)*fabs((*Vsub)-2*(*phiF)*qe)*1.1);
    /*qDebug()<<Q_FUNC_INFO
           <<"qe="<<qe<<" esub="<<(*esub)<<" e0="<<e0<<" Nsub="<<(*Nsub)<<" Vsub="<<(*Vsub)<<" phiF="<<(*phiF)<<" Vth="<<(*Vth)
          <<" phiF="<<(*phiF)<<" phims="<<(*phims)<<" Vsub+phiF*qe="<<(*Vsub)+2*(*phiF)*qe<<" esub*e0*Nsub="<<(*esub)*e0*(*Nsub)
         <<" eox="<<(*eox)<<" qb="<<(*qb);*/
    (*dox)=((-(*phims)*qe+2*(*phiF)*qe+(*Vth))*(*eox)*e0)
            /(sqrt(2*qe*(*eox)*e0*(*Nsub))*
              (fabs(-2*(*phiF)*qe+(*Vsub))-
               fabs(-2*(*phiF)*qe)));
    qDebug()<<" calc dox="<<(*dox);
    emit doxChanged(dox);
}

void calc_dox::set_model(/*QList<QObject *> &dataList*/){
    dataList.append(new data_vars("phims",phims,0.1,4,"eV"));
    dataList.append(new data_vars("phiF",phiF,0.7,0.9,"eV"));
    dataList.append(new data_vars("eox",eox,1.0,2000.0,""));
    dataList.append(new data_vars("esub",esub,1.0,2000.0,""));
    dataList.append(new data_vars("Nsub",Nsub,1.e14,1.e16,"sm^(-3)"));
    dataList.append(new data_vars("Vsub",Vsub,0.,10.,"V"));
    qDebug()<<Q_FUNC_INFO<<" dox="<<*dox;
    dataList.append(new data_vars("dox",dox,*dox,*dox,"sm"));
}

void calc_dox::ondoxCgd(double *ndox){
    qDebug()<<Q_FUNC_INFO<<" dox="<<*dox<<"ndox="<<*ndox; cnt++;
   /*delete dataList.takeLast();
    data_vars* tmpdv=qobject_cast<data_vars*> (dataList.at(dataList.size()-1);
    tmpdv->setParam_val(*dox);
    for(unsigned int i=0;i<dataList.size();i++){
        data_vars* tmpdv=qobject_cast<data_vars*> (dataList.at(i));
        qDebug()<<Q_FUNC_INFO<<(tmpdv->param_nm().toStdString()).c_str()<<' '<<tmpdv->param_val();
    }
    dataList.append(new data_vars("dox",dox,*dox,*dox,"sm"));*/
    qml_cntxt->setContextProperty("p_model", QVariant::fromValue(dataList));
}

calc_dox::~calc_dox(){
    delete phims;
    delete phiF;
    delete qox;
    delete eox;
    delete esub;
    delete Nsub;
    delete Vsub;
    delete Vth;
    delete dox;
    delete qb;
}

void calc_dox::set_r_objects(){
    pm_engine->load(QUrl(QLatin1String("qrc:/main.qml")));
    QDebug dbg=qDebug();
    //QList<QChart *> r_objects=pm_engine->rootObjects().at(0)->findChildren<QChart*>();
    //QList<QObject* > chldrn=r_objects.at(0)->findChildren<QObject*>();
    //QChart* r_objects=qobject_cast<QChart*> (pm_engine->rootObjects().at(0)->findChild<QObject*>("graph1"));
    /*if(r_objects)
        dbg<<r_objects->objectName();
    else
        dbg<<" nullptr";*/
    //dbg<<" "<<r_objects.size()<<" "<</*chldrn.size()<<*/" root objects: ";
//    for(unsigned int i=0;i<r_objects.size(); i++){
//        dbg<<" "<<r_objects.at(i)->objectName();
//    }

}

void calc_dox::set_points()
{
    /*QLineSeries *series = new QLineSeries();
    *series << QPointF(0, 6) << QPointF(9, 4) << QPointF(15, 20) << QPointF(25, 12) << QPointF(29, 26);
    QChart *chart= new QChart();

    chart->legend()->hide();
    chart->addSeries(series);*/
    QDebug debug=qDebug();
    _g1_points.clear();
    m_m_list->add_pnt(QPointF(),true);

    QFile fl("./src1.txt"); QFile fl1("./res1.txt"); QFile fl2("./res2.txt"); QFile fl3("./src2.txt");
    if(!fl.open(QIODevice::Truncate|QIODevice::WriteOnly)
            ||!fl1.open(QIODevice::Truncate|QIODevice::WriteOnly)
            ||!fl2.open(QIODevice::Truncate|QIODevice::WriteOnly)
            ||!fl3.open(QIODevice::Truncate|QIODevice::WriteOnly)
            ){
        debug<<"\nsave: cannot open"; //return;
    }

    QDataStream fl_stream(&fl),fl1_stream(&fl1),fl2_stream(&fl2),fl3_stream(&fl3);
    *Vth=0.5;// *Nsub=1e14;
    for(*Nsub=1e14;*Nsub<1e16;*Nsub+=(1e16-1e14)/(num_points+0.0)){
        fl_stream<<QString::number(*Nsub).toStdString().c_str()<<'\n';
        //*qb=-sqrt(2*qe*(*esub)*e0*(*Nsub)*fabs((*Vsub)-2*(*phiF)*qe));
        double d_tmp=(*phims)*qe-2*(*phiF)*qe+((*dox)*
                                               sqrt(fabs(2*qe*(*eox)*e0*(*Nsub)))*
                                               (sqrt(fabs(-2*(*phiF)*qe+(*Vsub)))-sqrt(fabs(-2*(*phiF)*qe)))
                                               )/((*eox)*e0);
        _g1_points.append(*Nsub); _g1_points.append(d_tmp);
        fl1_stream<<QString::number(
                        (*phims)*qe-2*(*phiF)*qe+((*dox)*
                            sqrt(fabs(2*qe*(*eox)*e0*(*Nsub)))*
                            (sqrt(fabs(-2*(*phiF)*qe+(*Vsub)))-sqrt(fabs(-2*(*phiF)*qe)))
                            )/((*eox)*e0)).toStdString().c_str()<<'\n';
    }
    *Vth=0.5; *Nsub=1e14;
    for((*Vsub)=0;(*Vsub)<10;(*Vsub)+=(10-0)/(num_points+0.0)){
        fl3_stream<<QString::number((*Vsub)).toStdString().c_str()<<'\n';
        *qb=-sqrt(2*qe*(*esub)*e0*(*Nsub)*fabs((*Vsub)-2*(*phiF)*qe));
        double d_tmp=(*phims)*qe-2*(*phiF)*qe+((*dox)*
            sqrt(fabs(2*qe*(*eox)*e0*(*Nsub)))*
            (sqrt(fabs(-2*(*phiF)*qe+(*Vsub)))-sqrt(fabs(-2*(*phiF)*qe)))
            )/((*eox)*e0);
        m_m_list->add_pnt(QPointF(*Vsub,d_tmp),false);
        fl2_stream<<QString::number(d_tmp).toStdString().c_str()<<'\n';
    }
    m_m_list->set_bnds();
    qml_cntxt->setContextProperty("l_model",m_m_list);
    fl.close(); fl1.close(); fl2.close(); fl3.close();
    qDebug()<<Q_FUNC_INFO;
    if(_g1_points.empty())
        qDebug()<<Q_FUNC_INFO<<" empt";
}

QVariantList calc_dox::g1_points() const{
    qDebug()<<Q_FUNC_INFO<<" here";
    return _g1_points;
}
