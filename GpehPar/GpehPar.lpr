program GpehPar;
{$mode objfpc}{$H+}
uses  Classes, GPEH_Eri, SysUtils;
var  //variables globales
  simplif: boolean = false;  //bandera para simplificar salida de eventos
  filtEven: integer = 0;     //bandera para filtrar un evento

Procedure log(cad : String);
begin
    write(cad);
//    lin := lin + cad;
End;
Procedure logn(cad : String);
begin
//    lin := lin + cad + #13#10;
    writeln(cad);
End;

procedure LeeEvento();
//Lee los datos de un registro de tipo 4 (evento)
var
  ScannerID : string;
  FechaHoraEve: String;
  eventID   : word;
  eventDes  : string;
  ueContextID: word;
  rncModuleId: longint;
  cellID1, rncID1: longint;
  cellID2, rncID2: longint;
  cellID3, rncID3: longint;
  cellID4, rncID4: longint;
begin
    //Lee cuerpo
    ScannerID := LeeScannerID;
    InicLecturaBit;  //prepara lectura por bits
    FechaHoraEve := LeeFechaHoraEve;
    eventID := LeeNBits(11);
    if filtEven <> 0 then begin  //Con filtro de evento activado
      if filtEven <> eventID then exit;
    end;
    if not simplif then logn('ScannerID:'+ScannerID);  //ScannerID
    if not simplif then logn(FechaHoraEve + ',' );  //muestra fecha hora
    case eventID of
    /////////// RNC Internal Events //////////////
    384: begin
      eventDes :='INTERNAL_IMSI';
    end;
    385: eventDes :='INTERNAL_RADIO_QUALITY_MEASUREMENTS_UEH';
    386: eventDes :='INTERNAL_RADIO_QUALITY_MEASUREMENTS_RNH';
    387: eventDes :='INTERNAL_CHANNEL_SWITCHING';
    388: eventDes :='INTERNAL_UL_OUTER_LOOP_POWER_CONTROL';
    389: eventDes :='INTERNAL_DL_POWER_MONITOR_UPDATE';
    390: eventDes :='INTERNAL_CELL_LOAD_MONITOR_UPDATE';
    391: eventDes :='INTERNAL_ADMISSION_CONTROL_RESPONSE';
    392: eventDes :='INTERNAL_CONGESTION_CONTROL_CHANNEL_SWITCH_AND_TERMINATE_RC';
    393: eventDes :='INTERNAL_START_CONGESTION';
    394: eventDes :='INTERNAL_STOP_CONGESTION';
    395: eventDes :='INTERNAL_DOWNLINK_CHANNELIZATION_CODE_ALLOCATION';
    397: eventDes :='INTERNAL_IRAT_HO_CC_REPORT_RECEPTION';
    398: eventDes :='INTERNAL_IRAT_HO_CC_EVALUATION';
    399: eventDes :='INTERNAL_IRAT_HO_CC_EXECUTION';
    400: eventDes :='INTERNAL_IRAT_CELL_CHANGE_DISCARDED_DATA';
    401: eventDes :='INTERNAL_CMODE_ACTIVATE';
    402: eventDes :='INTERNAL_CMODE_DEACTIVATE';
    403: eventDes :='INTERNAL_RRC_ERROR';
    404: eventDes :='INTERNAL_NBAP_ERROR';
    405: eventDes :='INTERNAL_RANAP_ERROR';
    406: eventDes :='INTERNAL_SOFT_HANDOVER_REPORT_RECEPTION';
    407: eventDes :='INTERNAL_SOFT_HANDOVER_EVALUATION';
    408: eventDes :='INTERNAL_SOFT_HANDOVER_EXECUTION';
    409: eventDes :='INTERNAL_CALL_REESTABLISHMENT';
    410: eventDes :='INTERNAL_MEASUREMENT_HANDLING_EVALUATION';
    411: eventDes :='INTERNAL_BMC_CBS_MESSAGE_DISCARDED';
    412: eventDes :='INTERNAL_BMC_CBS_MESSAGE_ATT_SCHEDULED';
    413: eventDes :='INTERNAL_RNSAP_ERROR';
    414: eventDes :='INTERNAL_RC_SUPERVISION';
    415: eventDes :='INTERNAL_RAB_ESTABLISHMENT';
    416: eventDes :='INTERNAL_RAB_RELEASE';
    417: eventDes :='INTERNAL_UE_MOVE';
    418: eventDes :='INTERNAL_UPLINK_SCRAMBLING_CODE_ALLOCATION';
    419: eventDes :='INTERNAL_MEASUREMENT_HANDLING_EXECUTION';
    420: eventDes :='INTERNAL_IFHO_REPORT_RECEPTION';
    421: eventDes :='INTERNAL_IFHO_EVALUATION';
    422: eventDes :='INTERNAL_IFHO_EXECUTION';
    423: eventDes :='INTERNAL_IFHO_EXECUTION_ACTIVE';
    425: eventDes :='INTERNAL_MP_OVERLOAD';
    426: eventDes :='INTERNAL_RBS_HW_MONITOR_UPDATE';
    427: eventDes :='INTERNAL_SOHO_DS_MISSING_NEIGHBOUR';
    428: eventDes :='INTERNAL_SOHO_DS_UNMONITORED_NEIGHBOUR';
    429: begin
      eventDes :='INTERNAL_UE_POSITIONING_QOS';
//      logn('EVENT_PARAM_NR_GPS_SATELLITES='+IntToStr(LeeNBits(6)));
    end;
    430: eventDes :='INTERNAL_UE_POSITIONING_UNSUCC';
    431: begin
      eventDes :='INTERNAL_SYSTEM_BLOCK';
{      logn('EVENT_PARAM_REQUESTED_SERVICE_CLASS='+IntToStr(LeeNBits(3)));
      logn('EVENT_PARAM_REQUESTED_SETUP_CLASS='+IntToStr(LeeNBits(2)));
      logn('EVENT_PARAM_REQUESTED_ORIGIN='+IntToStr(LeeNBits(2)));
      logn('EVENT_PARAM_REQUESTED_SF_DL='+IntToStr(LeeNBits(10)));
      logn('EVENT_PARAM_REQUESTED_SF_UL='+IntToStr(LeeNBits(6)));
      logn('EVENT_PARAM_REQUESTED_COMPRESSED_MODE='+IntToStr(LeeNBits(10)));
      logn('EVENT_PARAM_CURRENT_SF_DL='+IntToStr(LeeNBits(10)));
      logn('EVENT_PARAM_CURRENT_SF_UL='+IntToStr(LeeNBits(10)));
      logn('EVENT_PARAM_CURRENT_RAB_STATE='+IntToStr(LeeNBits(6)));
      logn('EVENT_PARAM_BLOCKING_PROCEDURE='+IntToStr(LeeNBits(4)));
      logn('EVENT_PARAM_BLOCK_REASON='+IntToStr(LeeNBits(6)));
      logn('EVENT_PARAM_BLOCK_TYPE='+IntToStr(LeeNBits(4)));
      logn('EVENT_PARAM_BLOCK_ADMISSION_POLICY_LEVEL='+IntToStr(LeeNBits(16)));
      logn('EVENT_PARAM_TRAFFIC_CLASS_UL='+IntToStr(LeeNBits(3)));
      logn('EVENT_PARAM_SOURCE_CONF='+IntToStr(LeeNBits(9)));
      logn('EVENT_PARAM_TARGET_CONF='+IntToStr(LeeNBits(9)));
      logn('EVENT_PARAM_ARP='+IntToStr(LeeNBits(5)));
      logn('EVENT_PARAM_GBR_UL='+IntToStr(LeeNBits(15)));}
    end;
    432: eventDes :='INTERNAL_SUCCESSFUL_HSDSCH_CELL_CHANGE';
    433: eventDes :='INTERNAL_FAILED_HSDSCH_CELL_CHANGE';
    434: eventDes :='INTERNAL_SUCCESSFUL_HSDSCH_CELL_SELECTION_OLD_ACTIVE_SET';
    435: eventDes :='INTERNAL_SUCCESSFUL_HSDSCH_CELL_SELECTION_NEW_ACTIVE_SET';
    436: eventDes :='INTERNAL_HSDSCH_CELL_SELECTION_NO_CELL_SELECTED';
    437: eventDes :='INTERNAL_TWO_NON_USED_FREQ_EXCEEDED';
    438: eventDes :='INTERNAL_SYSTEM_RELEASE';
    439: eventDes :='INTERNAL_CNHHO_EXECUTION_ACTIVE';
    440: eventDes :='INTERNAL_PS_RELEASE_DUE_TO_CNHHO';
    441: eventDes :='INTERNAL_PACKET_DEDICATED_THROUGHPUT';
    442: eventDes :='INTERNAL_SUCCESSFUL_TRANSITION_TO_DCH';
    443: eventDes :='INTERNAL_FAILED_TRANSITION_TO_DCH';
    444: eventDes :='INTERNAL_RECORDING_FAULT';
    445: eventDes :='INTERNAL_RECORDING_RECOVERED';
    446: eventDes :='INTERNAL_PACKET_DEDICATED_THROUGHPUT_STREAMING';
    447: eventDes :='INTERNAL_MBMS_SESSION_START_FAILED';
    448: eventDes :='INTERNAL_MBMS_SESSION_START_SUCCESS';
    449: eventDes :='INTERNAL_MBMS_SESSION_STOP_SYSTEM';
    450: eventDes :='INTERNAL_MBMS_SESSION_STOP_NORMAL';
    451: eventDes :='INTERNAL_SYSTEM_UTILIZATION';
    452: eventDes :='INTERNAL_PCAP_ERROR';
    453: eventDes :='INTERNAL_CBS_MESSAGE_ORDER_DISCARDED';
    454: eventDes :='INTERNAL_PACKET_DEDICATED_THROUGHPUT_CONV_UNKNOWN';
    455: eventDes :='INTERNAL_PACKET_DEDICATED_THROUGHPUT_CONV_SPEECH';
    456: eventDes :='INTERNAL_CALL_SETUP_FAIL';
    458: eventDes :='INTERNAL_OUT_HARD_HANDOVER_FAILURE';
    459: eventDes :='INTERNAL_RES_CPICH_ECNO';
    460: eventDes :='INTERNAL_CN_OVERLOAD_CONTROL_STATUS';
    461: eventDes :='INTERNAL_LOAD_CONTROL_ACTION';
    462: eventDes :='INTERNAL_LOAD_CONTROL_TRIGGER';
    475: eventDes :='INTERNAL_OUT_HARD_HANDOVER_SUCCESS';
    641: eventDes :='INTERNAL_MEAS_TRANSPORT_CHANNEL_BLER';

    //////////// Inter-Node Events ///////////////
    //RRC Events
    0 : eventDes :='RRC_ACTIVE_SET_UPDATE';
    1 : eventDes :='RRC_ACTIVE_SET_UPDATE_COMPLETE';
    2 : eventDes :='RRC_ACTIVE_SET_UPDATE_FAILURE';
    3 : eventDes :='RRC_CELL_UPDATE';
    4 : eventDes :='RRC_CELL_UPDATE_CONFIRM';
    5 : eventDes :='RRC_DOWNLINK_DIRECT_TRANSFER';
    6 : eventDes :='RRC_MEASUREMENT_CONTROL';
    7 : eventDes :='RRC_MEASUREMENT_CONTROL_FAILURE';
    8 : eventDes :='RRC_MEASUREMENT_REPORT';
    9 : eventDes :='RRC_PAGING_TYPE_2';
    10 : eventDes :='RRC_RADIO_BEARER_RECONFIGURATION';
    11 : eventDes :='RRC_RADIO_BEARER_RECONFIGURATION_COMPLETE';
    12 : eventDes :='RRC_RADIO_BEARER_RECONFIGURATION_FAILURE';
    13 : eventDes :='RRC_RADIO_BEARER_RELEASE';
    14 : eventDes :='RRC_RADIO_BEARER_RELEASE_COMPLETE';
    15 : eventDes :='RRC_RADIO_BEARER_RELEASE_FAILURE';
    16 : eventDes :='RRC_RADIO_BEARER_SETUP';
    17 : eventDes :='RRC_RADIO_BEARER_SETUP_COMPLETE';
    18 : eventDes :='RRC_RADIO_BEARER_SETUP_FAILURE';
    19 : eventDes :='RRC_RRC_CONNECTION_RELEASE';
    20 : eventDes :='RRC_RRC_CONNECTION_RELEASE_COMPLETE';
    21 : eventDes :='RRC_RRC_STATUS';
    22 : eventDes :='RRC_SECURITY_MODE_COMMAND';
    23 : eventDes :='RRC_SECURITY_MODE_COMPLETE';
    24 : eventDes :='RRC_SECURITY_MODE_FAILURE';
    25 : eventDes :='RRC_SIGNALLING_CONNECTION_RELEASE';
    26 : eventDes :='RRC_SIGNALLING_CONNECTION_RELEASE_INDICATION';
    27 : eventDes :='RRC_UE_CAPABILITY_INFORMATION';
    28 : eventDes :='RRC_UE_CAPABILITY_INFORMATION_CONFIRM';
    29 : eventDes :='RRC_UPLINK_DIRECT_TRANSFER';
    30 : eventDes :='RRC_UTRAN_MOBILITY_INFORMATION_CONFIRM';
    31 : eventDes :='RRC_INITIAL_DIRECT_TRANSFER';
    33 : eventDes :='RRC_RRC_CONNECTION_REJECT';
    34 : eventDes :='RRC_RRC_CONNECTION_REQUEST';
    35 : eventDes :='RRC_RRC_CONNECTION_SETUP';
    36 : eventDes :='RRC_RRC_CONNECTION_SETUP_COMPLETE';
    37 : eventDes :='RRC_SYSTEM_INFORMATION_CHANGE_INDICATION';
    38 : eventDes :='RRC_HANDOVER_FROM_UTRAN_COMMAND';
    39 : eventDes :='RRC_HANDOVER_FROM_UTRAN_FAILURE';
    40 : eventDes :='RRC_PHYSICAL_CHANNEL_RECONFIGURATION';
    41 : eventDes :='RRC_PHYSICAL_CHANNEL_RECONFIGURATION_COMPLETE';
    42 : eventDes :='RRC_PHYSICAL_CHANNEL_RECONFIGURATION_FAILURE';
    43 : eventDes :='RRC_UTRAN_MOBILITY_INFORMATION';
    44 : eventDes :='RRC_UTRAN_MOBILITY_INFORMATION_FAILURE';
    45 : eventDes :='RRC_CELL_CHANGE_ORDER_FROM_UTRAN';
    46 : eventDes :='RRC_CELL_CHANGE_ORDER_FROM_UTRAN_FAILURE';
    47 : eventDes :='RRC_UE_CAPABILITY_ENQUIRY';
    48 : eventDes :='RRC_URA_UPDATE';
    49 : eventDes :='RRC_URA_UPDATE_CONFIRM';
    50 : eventDes :='RRC_TRANSPORT_CHANNEL_RECONFIGURATION';
    51 : eventDes :='RRC_TRANSPORT_CHANNEL_RECONFIGURATION_COMPLETE';
    52 : eventDes :='RRC_MBMS_GENERAL_INFORMATION';
    53 : eventDes :='RRC_MBMS_MODIFIED_SERVICES_INFORMATION';
    54 : eventDes :='RRC_MBMS_UNMODIFIED_SERVICES_INFORMATION';
    55 : eventDes :='RRC_MBMS_COMMON_P_T_M_RB_INFORMATION';
    56 : eventDes :='RRC_MBMS_CURRENT_CELL_P_T_M_RB_INFORMATION';
    57 : eventDes :='RRC_MBMS_NEIGHBOURING_CELL_P_T_M_RB_INFORMATION';
    //NBAP Event detail
    128: eventDes :='NBAP_RADIO_LINK_SETUP_REQUEST';
    129: eventDes :='NBAP_RADIO_LINK_SETUP_RESPONSE';
    130: eventDes :='NBAP_RADIO_LINK_SETUP_FAILURE';
    131: eventDes :='NBAP_RADIO_LINK_ADDITION_REQUEST';
    132: eventDes :='NBAP_RADIO_LINK_ADDITION_RESPONSE';
    133: eventDes :='NBAP_RADIO_LINK_ADDITION_FAILURE';
    134: eventDes :='NBAP_RADIO_LINK_RECONFIGURATION_PREPARE';
    135: eventDes :='NBAP_RADIO_LINK_RECONFIGURATION_READY';
    136: eventDes :='NBAP_RADIO_LINK_RECONFIGURATION_FAILURE';
    137: eventDes :='NBAP_RADIO_LINK_RECONFIGURATION_COMMIT';
    138: eventDes :='NBAP_RADIO_LINK_RECONFIGURATION_CANCEL';
    139: eventDes :='NBAP_RADIO_LINK_DELETION_REQUEST';
    140: eventDes :='NBAP_RADIO_LINK_DELETION_RESPONSE';
    141: eventDes :='NBAP_DL_POWER_CONTROL_REQUEST';
    142: eventDes :='NBAP_DEDICATED_MEASUREMENT_INITIATION_REQUEST';
    143: eventDes :='NBAP_DEDICATED_MEASUREMENT_INITIATION_RESPONSE';
    144: eventDes :='NBAP_DEDICATED_MEASUREMENT_INITIATION_FAILURE';
    145: eventDes :='NBAP_DEDICATED_MEASUREMENT_REPORT';
    146: eventDes :='NBAP_DEDICATED_MEASUREMENT_TERMINATION_REQUEST';
    147: eventDes :='NBAP_DEDICATED_MEASUREMENT_FAILURE_INDICATION';
    148: eventDes :='NBAP_RADIO_LINK_FAILURE_INDICATION';
    149: eventDes :='NBAP_RADIO_LINK_RESTORE_INDICATION';
    150: eventDes :='NBAP_ERROR_INDICATION';
    151: eventDes :='NBAP_COMMON_TRANSPORT_CHANNEL_SETUP_REQUEST';
    152: eventDes :='NBAP_COMMON_TRANSPORT_CHANNEL_SETUP_RESPONSE';
    153: eventDes :='NBAP_COMMON_TRANSPORT_CHANNEL_SETUP_FAILURE';
    154: eventDes :='NBAP_COMMON_TRANSPORT_CHANNEL_RECONFIGURATION_REQUEST';
    155: eventDes :='NBAP_COMMON_TRANSPORT_CHANNEL_RECONFIGURATION_RESPONSE';
    156: eventDes :='NBAP_COMMON_TRANSPORT_CHANNEL_RECONFIGURATION_FAILURE';
    157: eventDes :='NBAP_COMMON_TRANSPORT_CHANNEL_DELETION_REQUEST';
    158: eventDes :='NBAP_COMMON_TRANSPORT_CHANNEL_DELETION_RESPONSE';
    159: eventDes :='NBAP_AUDIT_REQUIRED_INDICATION';
    160: eventDes :='NBAP_AUDIT_REQUEST';
    161: eventDes :='NBAP_AUDIT_RESPONSE';
    162: eventDes :='NBAP_AUDIT_FAILURE';
    163: eventDes :='NBAP_COMMON_MEASUREMENT_INITIATION_REQUEST';
    164: eventDes :='NBAP_COMMON_MEASUREMENT_INITIATION_RESPONSE';
    165: eventDes :='NBAP_COMMON_MEASUREMENT_INITIATION_FAILURE';
    166: eventDes :='NBAP_COMMON_MEASUREMENT_REPORT';
    167: eventDes :='NBAP_COMMON_MEASUREMENT_TERMINATION_REQUEST';
    168: eventDes :='NBAP_COMMON_MEASUREMENT_FAILURE_INDICATION';
    169: eventDes :='NBAP_CELL_SETUP_REQUEST';
    170: eventDes :='NBAP_CELL_SETUP_RESPONSE';
    171: eventDes :='NBAP_CELL_SETUP_FAILURE';
    172: eventDes :='NBAP_CELL_RECONFIGURATION_REQUEST';
    173: eventDes :='NBAP_CELL_RECONFIGURATION_RESPONSE';
    174: eventDes :='NBAP_CELL_RECONFIGURATION_FAILURE';
    175: eventDes :='NBAP_CELL_DELETION_REQUEST';
    176: eventDes :='NBAP_CELL_DELETION_RESPONSE';
    177: eventDes :='NBAP_RESOURCE_STATUS_INDICATION';
    178: eventDes :='NBAP_SYSTEM_INFORMATION_UPDATE_REQUEST';
    179: eventDes :='NBAP_SYSTEM_INFORMATION_UPDATE_RESPONSE';
    180: eventDes :='NBAP_SYSTEM_INFORMATION_UPDATE_FAILURE';
    181: eventDes :='NBAP_RESET_REQUEST';
    182: eventDes :='NBAP_RESET_RESPONSE';
    183: eventDes :='NBAP_COMPRESSED_MODE_COMMAND';
    184: eventDes :='NBAP_RADIO_LINK_PARAMETER_UPDATE_INDICATION';
    185: eventDes :='NBAP_PHYSICAL_SHARED_CHANNEL_RECONFIGURATION_REQUEST';
    186: eventDes :='NBAP_PHYSICAL_SHARED_CHANNEL_RECONFIGURATION_RESPONSE';
    187: eventDes :='NBAP_PHYSICAL_SHARED_CHANNEL_RECONFIGURATION_FAILURE';
    188: eventDes :='NBAP_MBMS_NOTIFICATION_UPDATE_COMMAND';
    //RANAP Events
    256: eventDes :='RANAP_RAB_ASSIGNMENT_REQUEST';
    257: eventDes :='RANAP_RAB_ASSIGNMENT_RESPONSE';
    258: eventDes :='RANAP_IU_RELEASE_REQUEST';
    259: eventDes :='RANAP_IU_RELEASE_COMMAND';
    260: eventDes :='RANAP_IU_RELEASE_COMPLETE';
    261: eventDes :='RANAP_SECURITY_MODE_COMMAND';
    262: eventDes :='RANAP_SECURITY_MODE_COMPLETE';
    263: eventDes :='RANAP_SECURITY_MODE_REJECT';
    264: eventDes :='RANAP_LOCATION_REPORTING_CONTROL';
    265: eventDes :='RANAP_DIRECT_TRANSFER';
    266: eventDes :='RANAP_ERROR_INDICATION';
    267: eventDes :='RANAP_PAGING';
    268: eventDes :='RANAP_COMMON_ID';
    269: eventDes :='RANAP_INITIAL_UE_MESSAGE';
    270: eventDes :='RANAP_RESET';
    271: eventDes :='RANAP_RESET_ACKNOWLEDGE';
    272: eventDes :='RANAP_RESET_RESOURCE';
    273: eventDes :='RANAP_RESET_RESOURCE_ACKNOWLEDGE';
    274: eventDes :='RANAP_RELOCATION_REQUIRED';
    275: eventDes :='RANAP_RELOCATION_REQUEST';
    276: eventDes :='RANAP_RELOCATION_REQUEST_ACKNOWLEDGE';
    277: eventDes :='RANAP_RELOCATION_COMMAND';
    278: eventDes :='RANAP_RELOCATION_DETECT';
    279: eventDes :='RANAP_RELOCATION_COMPLETE';
    280: eventDes :='RANAP_RELOCATION_PREPARATION_FAILURE';
    281: eventDes :='RANAP_RELOCATION_FAILURE';
    282: eventDes :='RANAP_RELOCATION_CANCEL';
    283: eventDes :='RANAP_RELOCATION_CANCEL_ACKNOWLEDGE';
    284: eventDes :='RANAP_SRNS_CONTEXT_REQUEST';
    285: eventDes :='RANAP_SRNS_CONTEXT_RESPONSE';
    286: eventDes :='RANAP_SRNS_DATA_FORWARD_COMMAND';
    287: eventDes :='RANAP_LOCATION_REPORT';
    288: eventDes :='RANAP_RANAP_RELOCATION_INFORMATION';
    289: eventDes :='RANAP_RAB_RELEASE_REQUEST';
    290: eventDes :='RANAP_MBMS_SESSION_START';
    291: eventDes :='RANAP_MBMS_SESSION_START_RESPONSE';
    292: eventDes :='RANAP_MBMS_SESSION_START_FAILURE';
    293: eventDes :='RANAP_MBMS_SESSION_STOP';
    294: eventDes :='RANAP_MBMS_SESSION_STOP_RESPONSE';
    else
       eventDes :='!!!Desconocido';
    end;
    logn('EventID=' + IntToStr(eventID) + ' - ' + eventDes);
    if simplif then begin
      //modo simplificado
    end else begin  //modo detallado
      //Puede ser un evento: RNC_Internal o Inter-Node
      UEcontextID := LeeNBits(16);
      log('UEcontextID=' + IntToStr(UEcontextID) + ',');
      rncModuleId := LeeNBits(7);
      logn('rncModuleId=' + IntToStr(rncModuleId)+',');
      cellID1:=LeeNBits(17);
      rncID1:=LeeNBits(13);
      logn('cellID1='+IntToStr(cellId1)+','+IntToStr(rncId1));
      cellID2:=LeeNBits(17);
      rncID2:=LeeNBits(13);
      logn('cellID2='+IntToStr(cellId2)+','+IntToStr(rncId2));
      cellID3:=LeeNBits(17);
      rncID3:=LeeNBits(13);
      logn('cellID3='+IntToStr(cellId3)+','+IntToStr(rncId3));
      cellID4:=LeeNBits(17);
      rncID4:=LeeNBits(13);
      logn('cellID4='+IntToStr(cellId4)+','+IntToStr(rncId4));
    end;
End;
procedure LeeHeader();
//Lee los datos de un registro de tipo header
begin
  logn('File Format Version:'+LeeCadena(5));
  logn(LeeFechaHoraFot);  //muestra fecha-hora
  logn('NE user label='+trim(LeeCadena(200)));
  logn('NE logical name='+trim(LeeCadena(200)));
  logn('File information version='+trim(LeeCadena(5)));
End;
procedure LeeRecording(nbytes: word);
//Lee los datos de un registro de tipo RECORDING
begin
  logn('Filter type='+IntToStr(LeeByte));
  logn('Filter='+trim(LeeCadena(nbytes-1)));
End;
procedure LeeProtocol();
//Lee los datos de un registro de tipo PROTOCOL
begin
  logn('Protocol ID='+IntToStr(LeeByte));
  logn('Protocol name='+trim(LeeCadena(50)));
  logn('Object Identiffier='+trim(LeeCadena(30)));
end;
procedure LeeLink();
//Lee los datos de un registro de tipo LINK
begin
  logn('File Path='+trim(LeeCadena(256)));

end;
procedure LeeFooter();
//Lee los datos de un registro de tipo FOOTER
begin
    log(LeeFechaHoraFot);  //muestra fecha-hora
End;

var arch: string;
    posSig: integer; //posición siguiente
    RecordLength : Integer;
    RecordType : Byte;
    npar: Integer;
    par: String;

begin
    if ParamCount <= 0 then begin
      //No hay línea de comandos
      writeln('Debe indicar archivo de entrada.');
      exit;
    end else begin
      //Hay parámetros
      for npar:=1 to ParamCount do begin
        par := ParamStr(npar);
        if par[1] = '-' then begin
          //es parámetro especial
          if par = '-s' then simplif := true;  //modo simplificado
          if copy(par,1,2) = '-e' then begin
            filtEven := StrToInt(copy(par,3,5));
          end;
        end else begin
          //se asume que es nombre de archivo
          arch := ParamStr(1);
        end;
      end;
    end;
    //verificaciónpar
    if not fileExists(arch) then begin
      WriteLn('Archivo no encontrado.');
      exit;
    end;
    //Lee todo el contenido del archivo
writeln('');
writeln('====='+arch+'=====');
    LeeArchivo(arch);
    //procesa
    While posArc<MaxBytes do begin
        RecordLength := LeeWord;
        if RecordLength = 0 then begin
           logn('Error: Encontrado registro de longitud cero en:' +
                        IntToStr(posArc)+'/'+IntToStr(MaxBytes) );
           break;
        end;
//        log('RecordLength=' + IntToStr(RecordLength)+ ' ');
        RecordType := LeeByte;
        posSig := posArc + RecordLength - 3;  //calcula posición para siguiente
        //Lee cuerpo
//        log(IntToSTr(RecordLength)+'-');
        case RecordType of  //identifica tipo de registro
        0: begin
             logn('HEADER:');
             LeeHeader();
             posArc := posSig;
           end;
        1: begin
             logn('RECORDING:');
             LeeRecording(RecordLength-3);
             posArc := posSig;
           end;
        2: begin
             logn('PROTOCOL:');
             LeeProtocol();
             posArc := posSig;
           end;
        4: begin
             if simplif or (filtEven<>0) then //log('EVENT:')
             else logn('EVENT:');
             LeeEvento();
             posArc := posSig;
           end;
        7: begin
             logn('FOOTER:');
             LeeFooter();
             posArc := posSig;
           end;
        8: begin
             logn('LINK:');
             LeeLink();
             posArc := posSig;
           end;
        Else
           begin   //Tipo desconocido
             logn('RecordType=' + IntToStr(RecordType) + ' DESCONOCIDO');
             posArc := posSig;
           End;
        end;
        if simplif or (filtEven<>0) then
        else logn('');
    end;
//    readln;
end.

