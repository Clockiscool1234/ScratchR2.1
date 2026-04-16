package sound
{
   import flash.utils.*;
   import soundbank.Instr;
   
   public class SoundBank
   {
      
      public static var instrumentNames:Array = ["Piano","Electric Piano","Organ","Guitar","Electric Guitar","Bass","Pizzicato","Cello","Trombone","Clarinet","Saxophone","Flute","Wooden Flute","Bassoon","Choir","Vibraphone","Music Box","Steel Drum","Marimba","Synth Lead","Synth Pad"];
      
      public static var drumNames:Array = ["Snare Drum","Bass Drum","Side Stick","Crash Cymbal","Open Hi-Hat","Closed Hi-Hat","Tambourine","Hand Clap","Claves","Wood Block","Cowbell","Triangle","Bongo","Conga","Cabasa","Guiro","Vibraslap","Open Cuica"];
      
      private static var instruments:Array = [[[38,"AcousticPiano_As3",58,10266,17053,[0,100,22]],[44,"AcousticPiano_C4",60,13968,18975,[0,100,20]],[51,"AcousticPiano_G4",67,12200,12370,[0,80,18]],[62,"AcousticPiano_C6",84,13042,13276,[0,80,16]],[70,"AcousticPiano_F5",77,12425,12965,[0,40,14]],[77,"AcousticPiano_Ds6",87,12368,12869,[0,20,10]],[85,"AcousticPiano_Ds6",87,12368,12869,[0,0,8]],[90,"AcousticPiano_Ds6",87,12368,12869,[0,0,6]],[96,"AcousticPiano_D7",98,7454,7606,[0,0,3]],[128,"AcousticPiano_D7",98,7454,7606,[0,0,2]]],[[48,"ElectricPiano_C2",36,15338,17360,[0,80,10]],[74,"ElectricPiano_C4",60,11426,12016,[0,40,8]],[128,"ElectricPiano_C4",60,11426,12016,[0,0,6]]],[[128,"Organ_G2",43,1306,3330]],[[40,"AcousticGuitar_F3",53,36665,36791,[0,0,15]],[56,"AcousticGuitar_F3",53,36665,36791,[0,0,13.5]],[60,"AcousticGuitar_F3",53,36665,36791,[0,0,12]],[67,"AcousticGuitar_F3",53,36665,36791,[0,0,8.5]],[72,"AcousticGuitar_F3",53,36665,36791,[0,0,7]],[83,"AcousticGuitar_F3",53,36665,36791,[0,0,5.5]]
      ,[128,"AcousticGuitar_F3",53,36665,36791,[0,0,4.5]]],[[40,"ElectricGuitar_F3",53,34692,34945,[0,0,15]],[56,"ElectricGuitar_F3",53,34692,34945,[0,0,13.5]],[60,"ElectricGuitar_F3",53,34692,34945,[0,0,12]],[67,"ElectricGuitar_F3",53,34692,34945,[0,0,8.5]],[72,"ElectricGuitar_F3",53,34692,34945,[0,0,7]],[83,"ElectricGuitar_F3",53,34692,34945,[0,0,5.5]],[128,"ElectricGuitar_F3",53,34692,34945,[0,0,4.5]]],[[34,"ElectricBass_G1",31,41912,42363,[0,0,17]],[48,"ElectricBass_G1",31,41912,42363,[0,0,14]],[64,"ElectricBass_G1",31,41912,42363,[0,0,12]],[128,"ElectricBass_G1",31,41912,42363,[0,0,10]]],[[38,"Pizz_G2",43,8554,8782,[0,0,5]],[45,"Pizz_G2",43,8554,8782,[0,12,4]],[56,"Pizz_A3",57,11460,11659,[0,0,4]],[64,"Pizz_A3",57,11460,11659,[0,0,3.2]],[72,"Pizz_E4",64,17525,17592,[0,0,2.8]],[80,"Pizz_E4",64,17525,17592,[0,0,2.2]],[128,"Pizz_E4",64,17525,17592,[0,0,1.5]]],[[41,"Cello_C2",36,8548,8885],[52,"Cello_As2",46,7465,7845],[62,"Violin_D4",62,10608,11360],[75,"Violin_A4",69,3111,3314,[70,0,0]],[128
      ,"Violin_E5",76,2383,2484]],[[30,"BassTrombone_A2_3",45,1357,2360],[40,"BassTrombone_A2_2",45,1893,2896],[55,"Trombone_B3",59,2646,3897],[88,"Trombone_B3",59,2646,3897,[50,0,0]],[128,"Trumpet_E5",76,2884,3152]],[[128,"Clarinet_C4",60,14540,15468]],[[40,"TenorSax_C3",48,8939,10794],[50,"TenorSax_C3",48,8939,10794,[20,0,0]],[59,"TenorSax_C3",48,8939,10794,[40,0,0]],[67,"AltoSax_A3",57,8546,9049],[75,"AltoSax_A3",57,8546,9049,[20,0,0]],[80,"AltoSax_A3",57,8546,9049,[20,0,0]],[128,"AltoSax_C6",84,1258,1848]],[[61,"Flute_B5_2",83,1859,2259],[128,"Flute_B5_1",83,2418,2818]],[[128,"WoodenFlute_C5",72,11426,15724]],[[57,"Bassoon_C3",48,2428,4284],[67,"Bassoon_C3",48,2428,4284,[40,0,0]],[76,"Bassoon_C3",48,2428,4284,[80,0,0]],[84,"EnglishHorn_F3",53,7538,8930,[40,0,0]],[128,"EnglishHorn_D4",62,4857,5231]],[[39,"Choir_F3",53,14007,41281],[50,"Choir_F3",53,14007,41281,[40,0,0]],[61,"Choir_F3",53,14007,41281,[60,0,0]],[72,"Choir_F4",65,16351,46436],[128,"Choir_F5",77,18440,45391]],[[38,"Vibraphone_C3"
      ,48,6202,6370,[0,100,8]],[48,"Vibraphone_C3",48,6202,6370,[0,100,7.5]],[59,"Vibraphone_C3",48,6202,6370,[0,60,7]],[70,"Vibraphone_C3",48,6202,6370,[0,40,6]],[78,"Vibraphone_C3",48,6202,6370,[0,20,5]],[86,"Vibraphone_C3",48,6202,6370,[0,0,4]],[128,"Vibraphone_C3",48,6202,6370,[0,0,3]]],[[128,"MusicBox_C4",60,14278,14700,[0,0,2]]],[[128,"SteelDrum_D5",74.4,-1,-1,[0,0,2]]],[[128,"Marimba_C4",60,-1,-1]],[[80,"SynthLead_C4",60,135,1400],[128,"SynthLead_C6",84,124,356]],[[38,"SynthPad_A3",57,4212,88017,[50,0,0]],[50,"SynthPad_A3",57,4212,88017,[80,0,0]],[62,"SynthPad_A3",57,4212,88017,[110,0,0]],[74,"SynthPad_A3",57,4212,88017,[150,0,0]],[86,"SynthPad_A3",57,4212,88017,[200,0,0]],[128,"SynthPad_C6",84,2575,9202]]];
      
      private static var drums:Array = [["SnareDrum",0],["Tom",0],["SideStick",0],["Crash",-7],["HiHatOpen",-8],["HiHatClosed",0],["Tambourine",0],["Clap",0],["Claves",0],["WoodBlock",-4],["Cowbell",0],["Triangle",-6,16843,17255,2],["Bongo",2],["Conga",-7,4247,4499,2],["Cabasa",0],["GuiroLong",0],["Vibraslap",-6],["Cuica",-5]];
      
      private static var oldDrums:Array = [["BassDrum",-7],["SideStick",0],["SnareDrum",0],["Tom",-5,7260,7483,3.2],["Tom",0,7260,7483,3],["Tom",7,7260,7483,2.7],["Tom",12,7260,7483,2.7],["HiHatClosed",0],["HiHatPedal",0],["HiHatOpen",-8],["Crash",-7],["Tambourine",0],["Clap",0],["WoodBlock",0],["WoodBlock",-4],["Claves",0],["Cowbell",0],["Triangle",-6,16843,17255,0.5],["Triangle",-6,16843,17255,4],["Bongo",2],["Bongo",-1],["Conga",-2,4247,4499,0.5],["Conga",-2,4247,4499,1],["Conga",-7,4247,4499,2],["Cabasa",0],["Maracas",0],["GuiroShort",0],["GuiroLong",0],["Vibraslap",-6],["Cuica",-5]];
      
      private static var midiDrums:Array = [["BassDrum",-4],["BassDrum",0],["SideStick",0],["SnareDrum",0],["Clap",0],["SnareDrum",2],["Tom",-6,7260,7483,4],["HiHatClosed",0],["Tom",-3,7260,7483,3.2],["HiHatPedal",0],["Tom",0,7260,7483,3],["HiHatOpen",-8],["Tom",4,7260,7483,3],["Tom",7,7260,7483,2.7],["Crash",-8],["Tom",10,7260,7483,2.7],["HiHatOpen",-2],["Crash",-11],["HiHatOpen",2],["Tambourine",0],["Crash",0,3.5],["Cowbell",0],["Crash",-8,-1,-1,3.5],["Vibraslap",-6],["HiHatOpen",2],["Bongo",2],["Bongo",0],["Conga",0,4247,4499,0.2],["Conga",0,4247,4499,2],["Conga",-5,4247,4499,2],["Bongo",12],["Bongo",5],["Cowbell",19],["Cowbell",12],["Cabasa",0],["Maracas",0],["Cuica",12],["Cuica",5],["GuiroShort",0],["GuiroLong",0],["Claves",0],["WoodBlock",0],["WoodBlock",-4],["Cuica",-5],["Cuica",0],["Triangle",-6,16843,17255,1],["Triangle",-6,16843,17255,3]];
      
      public function SoundBank()
      {
         super();
      }
      
      public static function getNotePlayer(param1:int, param2:int) : NotePlayer
      {
         Instr.initSamples();
         var _loc3_:Array = getNoteRecord(param1,param2);
         var _loc4_:Array = _loc3_.length > 5 ? _loc3_[5] : null;
         return new NotePlayer(Instr.samples[_loc3_[1]],pitchForKey(_loc3_[2]),_loc3_[3],_loc3_[4],_loc4_);
      }
      
      private static function getNoteRecord(param1:int, param2:int) : Array
      {
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         if(param1 < 0 || param1 >= instruments.length)
         {
            param1 = 0;
         }
         var _loc3_:Array = instruments[param1];
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = int(_loc4_[0]);
            if(param2 <= _loc5_)
            {
               return _loc4_;
            }
         }
         return _loc3_[_loc3_.length - 1];
      }
      
      private static function pitchForKey(param1:Number) : Number
      {
         return 440 * Math.pow(2,(param1 - 69) / 12);
      }
      
      public static function getDrumPlayer(param1:int, param2:Boolean, param3:Number) : NotePlayer
      {
         Instr.initSamples();
         var _loc4_:Array = param2 ? midiDrums[param1 - 35] : drums[param1 - 1];
         if(_loc4_ == null)
         {
            _loc4_ = drums[2];
         }
         var _loc5_:int = -1;
         var _loc6_:int = -1;
         var _loc7_:Array = null;
         if(_loc4_.length >= 4)
         {
            _loc5_ = int(_loc4_[2]);
            _loc6_ = int(_loc4_[3]);
         }
         if(_loc4_.length >= 5)
         {
            _loc7_ = [0,0,_loc4_[4]];
         }
         var _loc8_:NotePlayer = new NotePlayer(Instr.samples[_loc4_[0]],pitchForKey(60),_loc5_,_loc6_,_loc7_);
         _loc8_.setNoteAndDuration(60 + _loc4_[1],0);
         return _loc8_;
      }
      
      public static function checkInstruments() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:ByteArray = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:int = 0;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:int = 0;
         Instr.initSamples();
         for each(_loc2_ in instruments)
         {
            for each(_loc3_ in _loc2_)
            {
               if(_loc3_ != _loc1_)
               {
                  _loc4_ = _loc3_[1];
                  _loc5_ = int(_loc3_[2]);
                  _loc6_ = Instr.samples[_loc4_];
                  if(_loc6_)
                  {
                  }
                  _loc7_ = int(_loc3_[3]);
                  _loc8_ = int(_loc3_[4]);
                  if(_loc7_ >= 0)
                  {
                     _loc9_ = _loc8_ - _loc7_;
                     if(_loc9_ < 1)
                     {
                     }
                     _loc10_ = pitchForKey(_loc5_);
                     _loc11_ = 22050 / _loc10_;
                     _loc12_ = Math.round(_loc9_ / _loc11_);
                     _loc13_ = 22050 / (_loc9_ / _loc12_);
                     _loc14_ = 1200 * Math.log(_loc10_ / _loc13_) / Math.LN2;
                     _loc15_ = _loc6_.length / 2 - _loc8_;
                     if(_loc15_ < 0)
                     {
                     }
                  }
                  _loc1_ = _loc3_;
               }
            }
         }
      }
   }
}

