package cmd

import "io"

// FakeKoolService is a mock to be used on testing/replacement for KoolService interface
type FakeKoolService struct {
	ArgsExecute     []string
	ExitCode        int
	CalledExecute   bool
	CalledExit      bool
	CalledGetWriter bool
	CalledSetWriter bool
	CalledPrintln   bool
	CalledError     bool
	CalledWarning   bool
	CalledSuccess   bool
	MockExecError   error
}

// Execute mocks the function for testing
func (f *FakeKoolService) Execute(args []string) (err error) {
	f.ArgsExecute = args
	f.CalledExecute = true
	err = f.MockExecError
	return
}

// Exit mocks the function for testing
func (f *FakeKoolService) Exit(code int) {
	f.CalledExit = true
	f.ExitCode = code
}

// GetWriter mocks the function for testing
func (f *FakeKoolService) GetWriter() (w io.Writer) {
	f.CalledGetWriter = true
	return
}

// SetWriter mocks the function for testing
func (f *FakeKoolService) SetWriter(w io.Writer) {
	f.CalledSetWriter = true
}

// Println mocks the function for testing
func (f *FakeKoolService) Println(out ...interface{}) {
	f.CalledPrintln = true
}

// Error mocks the function for testing
func (f *FakeKoolService) Error(err error) {
	f.CalledError = true
}

// Warning mocks the function for testing
func (f *FakeKoolService) Warning(out ...interface{}) {
	f.CalledWarning = true
}

// Success mocks the function for testing
func (f *FakeKoolService) Success(out ...interface{}) {
	f.CalledSuccess = true
}
