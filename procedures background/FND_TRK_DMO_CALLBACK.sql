CREATE OR REPLACE PROCEDURE fnd_trk_dmo_callback(CONTEXT  RAW,
   reginfo  sys.aq$_reg_info,
   descr    sys.aq$_descriptor,
   payload  VARCHAR2,
   payloadl NUMBER)
IS   
BEGIN
   FND_OBJ_TRACKING_SYS.Tracking_Queue_Callback(CONTEXT, reginfo, descr, payload, payloadl);   
END;
