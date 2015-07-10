//
//
//  Created by 疯兔 on 15/7/10.
//  Copyright (c) 2015年 ZW. All rights reserved.
//

#import "EasyMonitBleWork.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "XcodeColorLogTools.h"
//指定服务UUID
NSString *const k_UUIDKEY = @"E7810A71-73AE-499D-8C15-FAA9AEF0C3F2";
//对应指令
NSString *const k_ORDER   = @"0x50";

@interface EasyMonitBleWork ()<CBCentralManagerDelegate,CBPeripheralDelegate>
@property (strong, nonatomic) CBCentralManager      *centralManager;
@property(copy,nonatomic)NSString *peripheralName;//外部设备名
@property(strong,nonatomic)dataCollectionBlock dataCollction;
@property(strong,nonatomic)CBPeripheral *discoveredPeripheral;
@property(strong,nonatomic)NSNumber *rssi;
@end

@implementation EasyMonitBleWork

-(void)BletoothDataCollectionFormName:(NSString *)peripheralName backData:(dataCollectionBlock)completionBlock
{
    _centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:dispatch_queue_create("Ble", 0)];
    _peripheralName = peripheralName;
    _dataCollction = completionBlock;
}

#pragma mark - CBCentralManagerDelegate 蓝牙中心代理方法的实现
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"%s / %tu",__FUNCTION__,central.state);
    NSInteger state = central.state;
    switch (state) {
        case CBCentralManagerStatePoweredOn:
            [_centralManager scanForPeripheralsWithServices:nil options:nil];
            break;
        default:
            NSLog(@"central Manager is not know");
            break;
    }
}
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    ZLogRed(@"scaning... %@...",_peripheralName);
    if ([self.peripheralName isEqualToString:peripheral.name]) {
        ZLogGreen(@"found ok");
        self.discoveredPeripheral = peripheral;
        self.rssi = RSSI;
        NSLog(@"found %@",self.peripheralName);
        NSLog(@"-!- %@ - %@ - %@",peripheral.name,peripheral.identifier.UUIDString,RSSI);
        [self.centralManager connectPeripheral:peripheral options:nil];
    }
    
}
-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"%@ is connect OK!!",peripheral.name);
    self.discoveredPeripheral.delegate = self;
    [_centralManager stopScan];
    NSLog(@"stop Scan!");
    
    //读出设备服务
    [_discoveredPeripheral discoverServices:nil];
}
//连接失败的回调
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"%s",__FUNCTION__);
}
-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    if (error) {
        NSLog(@"error %tu %@",error.code,[error localizedDescription]);
    }
    ZLogRed(@"断线重连中");
    [self.centralManager connectPeripheral:peripheral options:nil];
}

#pragma mark - CBPeripheralDelegate 蓝牙设备代理方法实现
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error) {
        ZLogRed(@"peripheral error %@",[error localizedDescription]);
    }else{
        NSLog(@"serviecs is begin");
        
        for (CBService *service in peripheral.services) {
            NSLog(@"servie UUID |%@|",service.UUID);
            
            if ([service.UUID.UUIDString isEqualToString:k_UUIDKEY]) {
                ZLogGreen(@"login this serviec %@",service.UUID);
                [_discoveredPeripheral discoverCharacteristics:nil forService:service];
            }
        }
    }
    
}
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    for(int i= 0; i < service.characteristics.count; i++) {
        CBCharacteristic *c = [service.characteristics objectAtIndex:i];
        ZLogLightSlateBlue(@"%@",c);
        NSData * myData = [self dataWithHexstring:k_ORDER];
        [peripheral writeValue:myData forCharacteristic:c type:0];
        [peripheral setNotifyValue:YES forCharacteristic:c];
    }
}
-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    ZLogGreen(@"write ----- %@",characteristic);
    if (error) {
        ZLogRed(@"%@",[error localizedDescription]);
    }
    
}
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        ZLogRed(@"error %@",[error localizedDescription]);
    }
    NSData *data = characteristic.value;
    if (_dataCollction) {
        _dataCollction(data);
    }
}

-(NSData*)dataWithHexstring:(NSString *)hexstring{
    NSMutableData* data = [NSMutableData data];
    int idx;
    for(idx = 0; idx + 2 <= hexstring.length; idx += 2){
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [hexstring substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}

//- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
//{
//    
//}
@end