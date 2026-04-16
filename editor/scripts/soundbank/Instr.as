package soundbank
{
   import flash.utils.*;
   import sound.WAVFile;
   
   public class Instr
   {
      
      public static var samples:Object;
      
      public static const AcousticGuitar_F3:Class = Instr_AcousticGuitar_F3;
      
      public static const AcousticPiano_As3:Class = Instr_AcousticPiano_As3;
      
      public static const AcousticPiano_C4:Class = Instr_AcousticPiano_C4;
      
      public static const AcousticPiano_G4:Class = Instr_AcousticPiano_G4;
      
      public static const AcousticPiano_F5:Class = Instr_AcousticPiano_F5;
      
      public static const AcousticPiano_C6:Class = Instr_AcousticPiano_C6;
      
      public static const AcousticPiano_Ds6:Class = Instr_AcousticPiano_Ds6;
      
      public static const AcousticPiano_D7:Class = Instr_AcousticPiano_D7;
      
      public static const AltoSax_A3:Class = Instr_AltoSax_A3;
      
      public static const AltoSax_C6:Class = Instr_AltoSax_C6;
      
      public static const Bassoon_C3:Class = Instr_Bassoon_C3;
      
      public static const BassTrombone_A2_2:Class = Instr_BassTrombone_A2_2;
      
      public static const BassTrombone_A2_3:Class = Instr_BassTrombone_A2_3;
      
      public static const Cello_C2:Class = Instr_Cello_C2;
      
      public static const Cello_As2:Class = Instr_Cello_As2;
      
      public static const Choir_F3:Class = Instr_Choir_F3;
      
      public static const Choir_F4:Class = Instr_Choir_F4;
      
      public static const Choir_F5:Class = Instr_Choir_F5;
      
      public static const Clarinet_C4:Class = Instr_Clarinet_C4;
      
      public static const ElectricBass_G1:Class = Instr_ElectricBass_G1;
      
      public static const ElectricGuitar_F3:Class = Instr_ElectricGuitar_F3;
      
      public static const ElectricPiano_C2:Class = Instr_ElectricPiano_C2;
      
      public static const ElectricPiano_C4:Class = Instr_ElectricPiano_C4;
      
      public static const EnglishHorn_D4:Class = Instr_EnglishHorn_D4;
      
      public static const EnglishHorn_F3:Class = Instr_EnglishHorn_F3;
      
      public static const Flute_B5_1:Class = Instr_Flute_B5_1;
      
      public static const Flute_B5_2:Class = Instr_Flute_B5_2;
      
      public static const Marimba_C4:Class = Instr_Marimba_C4;
      
      public static const MusicBox_C4:Class = Instr_MusicBox_C4;
      
      public static const Organ_G2:Class = Instr_Organ_G2;
      
      public static const Pizz_A3:Class = Instr_Pizz_A3;
      
      public static const Pizz_E4:Class = Instr_Pizz_E4;
      
      public static const Pizz_G2:Class = Instr_Pizz_G2;
      
      public static const SteelDrum_D5:Class = Instr_SteelDrum_D5;
      
      public static const SynthLead_C4:Class = Instr_SynthLead_C4;
      
      public static const SynthLead_C6:Class = Instr_SynthLead_C6;
      
      public static const SynthPad_A3:Class = Instr_SynthPad_A3;
      
      public static const SynthPad_C6:Class = Instr_SynthPad_C6;
      
      public static const TenorSax_C3:Class = Instr_TenorSax_C3;
      
      public static const Trombone_B3:Class = Instr_Trombone_B3;
      
      public static const Trumpet_E5:Class = Instr_Trumpet_E5;
      
      public static const Vibraphone_C3:Class = Instr_Vibraphone_C3;
      
      public static const Violin_D4:Class = Instr_Violin_D4;
      
      public static const Violin_A4:Class = Instr_Violin_A4;
      
      public static const Violin_E5:Class = Instr_Violin_E5;
      
      public static const WoodenFlute_C5:Class = Instr_WoodenFlute_C5;
      
      public static const BassDrum:Class = Instr_BassDrum;
      
      public static const Bongo:Class = Instr_Bongo;
      
      public static const Cabasa:Class = Instr_Cabasa;
      
      public static const Clap:Class = Instr_Clap;
      
      public static const Claves:Class = Instr_Claves;
      
      public static const Conga:Class = Instr_Conga;
      
      public static const Cowbell:Class = Instr_Cowbell;
      
      public static const Crash:Class = Instr_Crash;
      
      public static const Cuica:Class = Instr_Cuica;
      
      public static const GuiroLong:Class = Instr_GuiroLong;
      
      public static const GuiroShort:Class = Instr_GuiroShort;
      
      public static const HiHatClosed:Class = Instr_HiHatClosed;
      
      public static const HiHatOpen:Class = Instr_HiHatOpen;
      
      public static const HiHatPedal:Class = Instr_HiHatPedal;
      
      public static const Maracas:Class = Instr_Maracas;
      
      public static const SideStick:Class = Instr_SideStick;
      
      public static const SnareDrum:Class = Instr_SnareDrum;
      
      public static const Tambourine:Class = Instr_Tambourine;
      
      public static const Tom:Class = Instr_Tom;
      
      public static const Triangle:Class = Instr_Triangle;
      
      public static const Vibraslap:Class = Instr_Vibraslap;
      
      public static const WoodBlock:Class = Instr_WoodBlock;
      
      public function Instr()
      {
         super();
      }
      
      public static function initSamples() : void
      {
         var _loc2_:XML = null;
         var _loc3_:String = null;
         if(samples)
         {
            return;
         }
         samples = {};
         var _loc1_:XML = describeType(Instr);
         for each(_loc2_ in _loc1_.elements("constant"))
         {
            if(_loc2_.attribute("type") == "Class")
            {
               _loc3_ = _loc2_.attribute("name");
               samples[_loc3_] = getWAVSamples(new Instr[_loc3_]());
            }
         }
      }
      
      private static function getWAVSamples(param1:ByteArray) : ByteArray
      {
         var _loc2_:Object = WAVFile.decode(param1);
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.endian = Endian.LITTLE_ENDIAN;
         param1.position = _loc2_.sampleDataStart;
         param1.readBytes(_loc3_,0,2 * _loc2_.sampleCount);
         return _loc3_;
      }
   }
}

