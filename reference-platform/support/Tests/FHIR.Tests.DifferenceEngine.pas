unit FHIR.Tests.DifferenceEngine;

{
Copyright (c) 2011+, HL7 and Health Intersections Pty Ltd (http://www.healthintersections.com.au)
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

 * Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.
 * Neither the name of HL7 nor the names of its contributors may be used to
   endorse or promote products derived from this software without specific
   prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
}


interface

uses
  Windows, SysUtils, classes,
  FHIR.Support.Utilities, FHIR.Support.Stream,
  FHIR.Base.Objects, FHIR.Base.Parser, FHIR.Base.Factory, FHIR.Base.Common,
  FHIR.Version.Parser,
  {$IFDEF FHIR2}
  FHIR.R2.Tests.Worker, FHIR.R2.Resources, FHIR.R2.Types, FHIR.R2.Factory, FHIR.R2.Common,
  {$ENDIF}
  {$IFDEF FHIR3}
  FHIR.R3.Tests.Worker, FHIR.R3.Resources, FHIR.R3.Types, FHIR.R3.Factory, FHIR.R3.Common,
  {$ENDIF}
  {$IFDEF FHIR4}
  FHIR.R4.Tests.Worker, FHIR.R4.Resources, FHIR.R4.Types, FHIR.R4.Factory, FHIR.R4.Common,
  {$ENDIF}
  FHIR.Tools.DiffEngine,
  FHIR.Support.MXml, DUnitX.TestFramework;

Type
  [TextFixture]
  TDifferenceEngineTests = Class (TObject)
  Private
  Published
  End;

  DifferenceEngineTestCaseAttribute = class (CustomTestCaseSourceAttribute)
  protected
    function GetCaseInfoArray : TestCaseInfoArray; override;
  end;

  [TextFixture]
  TDifferenceEngineTest = Class (TObject)
  private
    tests : TMXmlElement;

    function makeFactory : TFHIRFactory;
    function findTest(index : integer) : TMXmlElement;
    function parseResource(elem : TMXmlElement) : TFhirResource;
    function AsXml(res : TFHIRResource) : String;
    procedure CompareXml(name, mode : String; expected, obtained : TFHIRResource);
    procedure execCase(name : String; mode : String; input : TFhirResource; diff : TFhirParameters; output : TFhirResource);
  Published
    [SetupFixture] procedure setup;
    [TearDownFixture] procedure teardown;

    [DifferenceEngineTestCase]
    procedure DifferenceEngineTest(Name : String);
  End;

implementation

{ DifferenceEngineTestCaseAttribute }

function DifferenceEngineTestCaseAttribute.GetCaseInfoArray: TestCaseInfoArray;
var
  test : TMXmlElement;
  tests : TMXmlElement;
  i : integer;
  s : String;
begin
  tests := TMXmlParser.ParseFile('C:\work\org.hl7.fhir\build\tests\patch\fhir-path-tests.xml', [xpDropWhitespace]);
  try
    test := tests.document.first;
    i := 0;
    while test <> nil do
    begin
      if test.NodeType = ntElement then
      begin
        s := test.attribute['name'];
        SetLength(result, i+1);
        result[i].Name := s;
        SetLength(result[i].Values, 1);
        result[i].Values[0] := inttostr(i);
        inc(i);
      end;
      test := test.nextElement;
    end;
  finally
    tests.free;
  end;
end;


{ TDifferenceEngineTest }

function TDifferenceEngineTest.findTest(index : integer): TMXmlElement;
var
  test : TMXmlElement;
  i : integer;
begin
  test := tests.document.first;
  i := 0;
  while test <> nil do
  begin
    if test.NodeType = ntElement then
    begin
      if i = index then
        exit(test);
      inc(i);
    end;
    test := test.nextElement;
  end;
  result := nil;
end;

function TDifferenceEngineTest.makeFactory: TFHIRFactory;
begin
  {$IFDEF FHIR2} result := TFHIRFactoryR2.Create; {$ENDIF}
  {$IFDEF FHIR3} result := TFHIRFactoryR3.Create; {$ENDIF}
  {$IFDEF FHIR4} result := TFHIRFactoryR4.Create; {$ENDIF}
end;

procedure TDifferenceEngineTest.DifferenceEngineTest(Name: String);
var
  test : TMXmlElement;
  input, output : TFhirResource;
  diff : TFhirParameters;
begin
  test := findTest(StrToInt(name));
  input := parseResource(test.element('input'));
  try
    output := parseResource(test.element('output'));
    try
      diff := parseResource(test.element('diff')) as TFHIRParameters;
      try
        execCase(test.attribute['name'], test.attribute['mode'], input, diff, output);
      finally
        diff.Free;
      end;
    finally
      output.free;
    end;
  finally
    input.Free;
  end;
end;

function TDifferenceEngineTest.AsXml(res: TFHIRResource): String;
var
  p : TFHIRXmlComposer;
  s : TStringStream;
begin
  p := TFHIRXmlComposer.Create(nil, OutputStylePretty, 'en');
  try
    s := TStringStream.Create;
    try
      p.Compose(s, res);
      result := s.DataString;
    finally
      s.Free;
    end;
  finally
    p.Free;
  end;

end;

procedure TDifferenceEngineTest.CompareXml(name, mode : String; expected, obtained: TFHIRResource);
var
  e, o : String;
begin
  e := asXml(expected);
  o := asXml(obtained);
  StringToFile(e, 'c:\temp\expected.xml', TEncoding.UTF8);
  StringToFile(o, 'c:\temp\obtained.xml', TEncoding.UTF8);
  Assert.IsTrue(e = o, mode+' does not match for '+name);
end;

procedure TDifferenceEngineTest.execCase(name: String; mode : String; input: TFhirResource; diff: TFhirParameters; output: TFhirResource);
var
  engine : TDifferenceEngine;
  delta : TFhirParametersW;
  outcome : TFhirResource;
  html : String;
  w : TFhirParametersW;
begin
  if (mode = 'both') or (mode = 'reverse') then
  begin
    engine := TDifferenceEngine.Create(TTestingWorkerContext.Use, makeFactory);
    try
      delta := engine.generateDifference(input, output, html);
      try
        compareXml(name, 'Difference', diff, delta.Resource as TFHIRParameters);
      finally
        delta.Free;
      end;
    finally
      engine.free;
    end;
  end;

  if (mode = 'both') or (mode = 'forwards') then
  begin
    engine := TDifferenceEngine.Create(TTestingWorkerContext.Use, makeFactory);
    try
      {$IFDEF FHIR2}
      w := TFhirParameters2.create(diff.link);
      {$ELSE}
      {$IFDEF FHIR3}
      w := TFhirParameters3.create(diff.link);
      {$ELSE}
      w := TFhirParameters4.create(diff.link);
      {$ENDIF}
      {$ENDIF}
      try
        outcome := engine.applyDifference(input, w) as TFhirResource;
        try
          compareXml(name, 'Output', output, outcome);
        finally
          outcome.Free;
        end;
      finally
        w.free;
      end;
    finally
      engine.free;
    end;
  end;
end;

function TDifferenceEngineTest.parseResource(elem: TMXmlElement): TFhirResource;
var
  p : TFHIRXmlParser;
begin

  p := TFHIRXmlParser.Create(nil, 'en');
  try
    p.Element := elem.firstElement.Link;
    p.Parse;
    result := p.resource.Link as TFHIRResource;
  finally
    p.Free;
  end;

end;

procedure TDifferenceEngineTest.setup;
begin
  tests := TMXmlParser.ParseFile('C:\work\org.hl7.fhir\build\tests\patch\fhir-path-tests.xml', [xpResolveNamespaces]);
end;

procedure TDifferenceEngineTest.teardown;
begin
  tests.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TDifferenceEngineTest);
  TDUnitX.RegisterTestFixture(TDifferenceEngineTests);
end.
