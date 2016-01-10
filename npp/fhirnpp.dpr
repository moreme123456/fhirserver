library fhirnpp;

{$R 'helloworldres.res' 'helloworldres.rc'}

uses
  FastMM4 in '..\Libraries\FMM\FastMM4.pas',
  FastMM4Messages in '..\Libraries\FMM\FastMM4Messages.pas',
  SysUtils,
  Classes,
  Types,
  Windows,
  Messages,
  nppplugin in 'npplib\nppplugin.pas',
  SciSupport in 'npplib\SciSupport.pas',
  NppForms in 'npplib\NppForms.pas' {NppForm},
  NppDockingForms in 'npplib\NppDockingForms.pas' {NppDockingForm},
  FHIRPlugin in 'FHIRPlugin.pas',
  SettingsForm in 'SettingsForm.pas' {SettingForm},
  FHIRToolboxForm in 'FHIRToolboxForm.pas' {FHIRToolbox},
  FHIRPluginSettings in 'FHIRPluginSettings.pas',
  FHIRValidator in '..\Libraries\refplat2\FHIRValidator.pas',
  RegExpr in '..\Libraries\support\RegExpr.pas',
  StringSupport in '..\Libraries\support\StringSupport.pas',
  MathSupport in '..\Libraries\support\MathSupport.pas',
  AdvObjects in '..\Libraries\support\AdvObjects.pas',
  AdvExceptions in '..\Libraries\support\AdvExceptions.pas',
  AdvFactories in '..\Libraries\support\AdvFactories.pas',
  FileSupport in '..\Libraries\support\FileSupport.pas',
  MemorySupport in '..\Libraries\support\MemorySupport.pas',
  DateSupport in '..\Libraries\support\DateSupport.pas',
  ErrorSupport in '..\Libraries\support\ErrorSupport.pas',
  SystemSupport in '..\Libraries\support\SystemSupport.pas',
  ThreadSupport in '..\Libraries\support\ThreadSupport.pas',
  EncodeSupport in '..\Libraries\support\EncodeSupport.pas',
  AdvControllers in '..\Libraries\support\AdvControllers.pas',
  AdvPersistents in '..\Libraries\support\AdvPersistents.pas',
  AdvFilers in '..\Libraries\support\AdvFilers.pas',
  ColourSupport in '..\Libraries\support\ColourSupport.pas',
  CurrencySupport in '..\Libraries\support\CurrencySupport.pas',
  AdvPersistentLists in '..\Libraries\support\AdvPersistentLists.pas',
  AdvObjectLists in '..\Libraries\support\AdvObjectLists.pas',
  AdvItems in '..\Libraries\support\AdvItems.pas',
  AdvCollections in '..\Libraries\support\AdvCollections.pas',
  AdvIterators in '..\Libraries\support\AdvIterators.pas',
  AdvClassHashes in '..\Libraries\support\AdvClassHashes.pas',
  AdvHashes in '..\Libraries\support\AdvHashes.pas',
  HashSupport in '..\Libraries\support\HashSupport.pas',
  AdvStringHashes in '..\Libraries\support\AdvStringHashes.pas',
  AdvProfilers in '..\Libraries\support\AdvProfilers.pas',
  AdvStringIntegerMatches in '..\Libraries\support\AdvStringIntegerMatches.pas',
  AdvStreams in '..\Libraries\support\AdvStreams.pas',
  AdvParameters in '..\Libraries\support\AdvParameters.pas',
  AdvExclusiveCriticalSections in '..\Libraries\support\AdvExclusiveCriticalSections.pas',
  AdvThreads in '..\Libraries\support\AdvThreads.pas',
  AdvSignals in '..\Libraries\support\AdvSignals.pas',
  AdvSynchronizationRegistries in '..\Libraries\support\AdvSynchronizationRegistries.pas',
  AdvTimeControllers in '..\Libraries\support\AdvTimeControllers.pas',
  AdvIntegerMatches in '..\Libraries\support\AdvIntegerMatches.pas',
  AdvBuffers in '..\Libraries\support\AdvBuffers.pas',
  BytesSupport in '..\Libraries\support\BytesSupport.pas',
  AdvStringBuilders in '..\Libraries\support\AdvStringBuilders.pas',
  AdvFiles in '..\Libraries\support\AdvFiles.pas',
  AdvLargeIntegerMatches in '..\Libraries\support\AdvLargeIntegerMatches.pas',
  AdvStringLargeIntegerMatches in '..\Libraries\support\AdvStringLargeIntegerMatches.pas',
  AdvStringLists in '..\Libraries\support\AdvStringLists.pas',
  AdvCSVFormatters in '..\Libraries\support\AdvCSVFormatters.pas',
  AdvTextFormatters in '..\Libraries\support\AdvTextFormatters.pas',
  AdvFormatters in '..\Libraries\support\AdvFormatters.pas',
  AdvCSVExtractors in '..\Libraries\support\AdvCSVExtractors.pas',
  AdvTextExtractors in '..\Libraries\support\AdvTextExtractors.pas',
  AdvExtractors in '..\Libraries\support\AdvExtractors.pas',
  AdvCharacterSets in '..\Libraries\support\AdvCharacterSets.pas',
  AdvOrdinalSets in '..\Libraries\support\AdvOrdinalSets.pas',
  AdvStreamReaders in '..\Libraries\support\AdvStreamReaders.pas',
  AdvStringStreams in '..\Libraries\support\AdvStringStreams.pas',
  AdvGenerics in '..\Libraries\support\AdvGenerics.pas',
  AdvJSON in '..\Libraries\support\AdvJSON.pas',
  AdvVCLStreams in '..\Libraries\support\AdvVCLStreams.pas',
  AdvStringObjectMatches in '..\Libraries\support\AdvStringObjectMatches.pas',
  AdvNameBuffers in '..\Libraries\support\AdvNameBuffers.pas',
  AdvMemories in '..\Libraries\support\AdvMemories.pas',
  FHIRBase in '..\Libraries\refplat2\FHIRBase.pas',
  DateAndTime in '..\Libraries\support\DateAndTime.pas',
  DecimalSupport in '..\Libraries\support\DecimalSupport.pas',
  GUIDSupport in '..\Libraries\support\GUIDSupport.pas',
  KDate in '..\Libraries\support\KDate.pas',
  HL7V2DateSupport in '..\Libraries\support\HL7V2DateSupport.pas',
  AdvNames in '..\Libraries\support\AdvNames.pas',
  AdvStringMatches in '..\Libraries\support\AdvStringMatches.pas',
  FHIRUtilities in '..\Libraries\refplat2\FHIRUtilities.pas',
  OIDSupport in '..\Libraries\support\OIDSupport.pas',
  TextUtilities in '..\Libraries\support\TextUtilities.pas',
  FHIRSupport in '..\Libraries\refplat2\FHIRSupport.pas',
  JWT in '..\Libraries\support\JWT.pas',
  HMAC in '..\Libraries\support\HMAC.pas',
  libeay32 in '..\Libraries\support\libeay32.pas',
  SCIMObjects in '..\Libraries\refplat2\SCIMObjects.pas',
  FHIRResources in '..\Libraries\refplat2\FHIRResources.pas',
  FHIRTypes in '..\Libraries\refplat2\FHIRTypes.pas',
  FHIRConstants in '..\Libraries\refplat2\FHIRConstants.pas',
  FHIRSecurity in '..\Libraries\refplat2\FHIRSecurity.pas',
  FHIRTags in '..\Libraries\refplat2\FHIRTags.pas',
  FHIRLang in '..\Libraries\refplat2\FHIRLang.pas',
  AfsResourceVolumes in '..\Libraries\support\AfsResourceVolumes.pas',
  AfsVolumes in '..\Libraries\support\AfsVolumes.pas',
  AfsStreamManagers in '..\Libraries\support\AfsStreamManagers.pas',
  AdvObjectMatches in '..\Libraries\support\AdvObjectMatches.pas',
  FHIRParser in '..\Libraries\refplat2\FHIRParser.pas',
  FHIRParserBase in '..\Libraries\refplat2\FHIRParserBase.pas',
  MsXmlParser in '..\Libraries\support\MsXmlParser.pas',
  XMLBuilder in '..\Libraries\support\XMLBuilder.pas',
  AdvWinInetClients in '..\Libraries\support\AdvWinInetClients.pas',
  MsXmlBuilder in '..\Libraries\support\MsXmlBuilder.pas',
  AdvXmlBuilders in '..\Libraries\support\AdvXmlBuilders.pas',
  AdvXMLFormatters in '..\Libraries\support\AdvXMLFormatters.pas',
  AdvXMLEntities in '..\Libraries\support\AdvXMLEntities.pas',
  FHIRProfileUtilities in '..\Libraries\refplat2\FHIRProfileUtilities.pas',
  AdvZipReaders in '..\Libraries\support\AdvZipReaders.pas',
  AdvZipDeclarations in '..\Libraries\support\AdvZipDeclarations.pas',
  AdvZipParts in '..\Libraries\support\AdvZipParts.pas',
  AdvZipUtilities in '..\Libraries\support\AdvZipUtilities.pas',
  AdvZipWorkers in '..\Libraries\support\AdvZipWorkers.pas',
  kCritSct in '..\Libraries\support\kCritSct.pas',
  FHIRPluginValidator in 'FHIRPluginValidator.pas',
  FHIRClient in '..\Libraries\refplat2\FHIRClient.pas',
  NewResourceForm in 'NewResourceForm.pas' {ResourceNewForm},
  FHIRNarrativeGenerator in '..\Libraries\refplat2\FHIRNarrativeGenerator.pas',
  NewServerForm in 'NewServerForm.pas' {RegisterServerForm},
  SmartOnFhirLogin in '..\Libraries\refplat2\SmartOnFhirLogin.pas' {SmartOnFhirLoginForm},
  ParseMap in '..\Libraries\support\ParseMap.pas',
  SmartOnFhirUtilities in '..\Libraries\refplat2\SmartOnFhirUtilities.pas',
  FetchResourceForm in 'FetchResourceForm.pas' {FetchResourceFrm},
  VirtualTrees in '..\..\Components\vtree\Source\VirtualTrees.pas',
  FHIRPath in '..\Libraries\refplat2\FHIRPath.pas',
  FHIRPathDocumentation in 'FHIRPathDocumentation.pas' {FHIRPathDocumentationForm},
  MimeMessage in '..\Libraries\support\MimeMessage.pas',
  PathDialogForms in 'PathDialogForms.pas' {PathDialogForm},
  ValidationOutcomes in 'ValidationOutcomes.pas' {ValidationOutcomeForm},
  FHIRVisualiser in 'FHIRVisualiser.pas' {FHIRVisualizer},
  FHIRPathDebugger in '..\Libraries\refplat2\FHIRPathDebugger.pas' {FHIRPathDebuggerForm},
  WelcomeScreen in 'WelcomeScreen.pas' {WelcomeScreenForm},
  nppbuildcount in 'nppbuildcount.pas',
  UpgradePrompt in 'UpgradePrompt.pas' {UpgradePromptForm},
  PluginUtilities in 'PluginUtilities.pas',
  CDSHooksUtilities in '..\Libraries\refplat2\CDSHooksUtilities.pas',
  MarkdownDaringFireball in '..\..\markdown\source\MarkdownDaringFireball.pas',
  MarkdownProcessor in '..\..\markdown\source\MarkdownProcessor.pas',
  ShellSupport in '..\Libraries\support\ShellSupport.pas',
  CDSBrowserForm in 'CDSBrowserForm.pas' {CDSBrowser};

{$R *.res}

{$Include 'npplib\NppPluginInclude.pas'}

begin
  { First, assign the procedure to the DLLProc variable }
  DllProc := @DLLEntryPoint;
  { Now invoke the procedure to reflect that the DLL is attaching to the process }
  DLLEntryPoint(DLL_PROCESS_ATTACH);
end.
